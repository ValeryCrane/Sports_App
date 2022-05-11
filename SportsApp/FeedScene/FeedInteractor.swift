//
//  FeedInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import CoreLocation

protocol FeedBusinessLogic {
    func fetchFeed()
}

class FeedInteractor {
    var presenter: FeedPresentationLogic!
    
    private func createFeedRequest() -> URLRequest {
        let urlString = "\(Settings.host)feed"
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
    
    private func requestFeed() {
        let request = createFeedRequest()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data,
               let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let json = jsonObject as? [String: Any],
               let jsonFeed = json["rides"] as? [[String: Any]] {
                let feed = jsonFeed.compactMap({ Ride(fromJson: $0) })
                self?.presenter.presentFeed(feed)
                for ride in feed {
                    self?.requestRoute(rideId: ride.id)
                }
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
}

extension FeedInteractor: FeedBusinessLogic {
    func fetchFeed() {
        requestFeed()
    }
    
}


