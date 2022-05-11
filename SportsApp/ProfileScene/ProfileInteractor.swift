//
//  ProfileInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation
import CoreLocation

protocol ProfileBusinessLogic {
    func fetchData()
    func processButtonPress(buttonType: ProfileButtonType)
}

class ProfileInteractor {
    var presenter: ProfilePresentationLogic!
    private let userId: Int?
    
    init() {
        userId = nil
    }
    
    init(userId: Int) {
        self.userId = userId
    }
    
    // MARK: - Request creation functions
    private func createUserInfoRequest() -> URLRequest {
        var urlString = "\(Settings.host)info"
        if let userId = userId { urlString += "?userId=\(userId)" }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        return request
    }
    
    private func createRidesRequest() -> URLRequest {
        var urlString = "\(Settings.host)rides"
        if let userId = userId { urlString += "?userId=\(userId)" }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        return request
    }
    
    private func createRouteRequest(rideId: Int) -> URLRequest {
        let url = URL(string: "\(Settings.host)route?rideId=\(rideId)")!
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        return request
    }
    
    private func createFollowRequest() -> URLRequest? {
        guard let userId = userId else { return nil }
        let urlString = "\(Settings.host)follow?userId=\(userId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        return request
    }
    
    private func createUnfollowRequest() -> URLRequest? {
        guard let userId = userId else { return nil }
        let urlString = "\(Settings.host)unfollow?userId=\(userId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        return request
    }
    
    // MARK: - Request functions
    private func requestUserInfo() {
        let request = createUserInfoRequest()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if
                let data = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: data),
                let jsonUser = jsonObject as? [String: Any],
                let name = jsonUser["name"] as? String,
                let relation = jsonUser["relation"] as? String,
                let statistics = jsonUser["statistics"] as? [String: Any]
            {
                var parameters = [Parameter]()
                for statistic in statistics {
                    guard
                        let value = statistic.value as? Double,
                        let parameter = Speed.getParameter(feature: statistic.key, value: value)
                    else {
                        self?.presenter.presentError(message: "Check your internet connection!")
                        return
                    }
                    parameters.append(parameter)
                }
                self?.presenter.present(lastWeekStatistics: parameters,
                                        username: name,
                                        andRelationType: relation)
            } else {
                self?.presenter.presentError(message: "Check your internet connection!")
            }
        }
        task.resume()
    }
    
    private func requestRides() {
        let request = createRidesRequest()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data,
               let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let json = jsonObject as? [String: Any],
               let jsonRides = json["rides"] as? [[String: Any]] {
                let rides = jsonRides.compactMap({ Ride(fromJson: $0) })
                for ride in rides {
                    self?.requestRoute(rideId: ride.id)
                }
                self?.presenter.presentRides(rides)
            } else {
                self?.presenter.presentError(message: "Check your internet connection!")
            }
        }
        task.resume()
    }
    
    private func requestRoute(rideId: Int) {
        let request = createRouteRequest(rideId: rideId)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data,
               let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let json = jsonObject as? [String: Any],
               let jsonRoute = json["route"] as? [[[String: Any]]] {
                let route = jsonRoute.map({ segment -> [CLLocationCoordinate2D] in
                    segment.compactMap({ point -> CLLocationCoordinate2D? in
                        guard
                            let latitude = point["latitude"] as? Double,
                            let longitude = point["longitude"] as? Double
                        else { return nil }
                        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    })
                })
                self?.presenter.presentRoute(route, forRideId: rideId)
            }
        }
        task.resume()
    }
    
    private func requestFollow() {
        guard let request = createFollowRequest() else {
            presenter.presentError(message: "You can't follow yourself!")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                self?.presenter.presentButtonType(.unfollow)
            } else if let data = data {
                self?.presenter.presentError(message: String(data: data, encoding: .utf8) ?? "Something went wrong!")
            } else {
                self?.presenter.presentError(message: "Something went wrong!")
            }
        }
        task.resume()
    }
    
    private func requestUnfollow() {
        guard let request = createUnfollowRequest() else {
            presenter.presentError(message: "You can't unfollow yourself!")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                self?.presenter.presentButtonType(.follow)
            } else if let data = data {
                self?.presenter.presentError(message: String(data: data, encoding: .utf8) ?? "Something went wrong!")
            } else {
                self?.presenter.presentError(message: "Something went wrong!")
            }
        }
        task.resume()
    }
}

extension ProfileInteractor: ProfileBusinessLogic {
    func fetchData() {
        presenter.startPresenting()
        requestUserInfo()
        requestRides()
    }
    
    func processButtonPress(buttonType: ProfileButtonType) {
        switch buttonType {
        case .follow:
            requestFollow()
        case .unfollow:
            requestUnfollow()
        case .settings:
            print("Not implemented yet!")
        }
    }
}

