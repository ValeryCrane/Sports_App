//
//  ProfilePresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation
import CoreLocation

protocol ProfilePresentationLogic {
    func presentError(message: String)
    func presentRides(_ rides: [Ride])
    func presentRoute(_ route: [[CLLocationCoordinate2D]], forRideId rideId: Int)
    func present(lastWeekStatistics parameters: [Parameter], username: String,
                 andRelationType relationType: String)
    func presentButtonType(_ buttonType: ProfileButtonType)
    func startPresenting()
}

class ProfilePresenter {
    weak var view: ProfileDisplayLogic!
    private var rides = [Ride]()
    private var isUserInfoPresented = false
    private var areRidesPresented = false
}

extension ProfilePresenter: ProfilePresentationLogic {
    func startPresenting() {
        isUserInfoPresented = false
        areRidesPresented = false
    }
    
    func presentError(message: String) {
        DispatchQueue.main.async { [weak view] in
            view?.displayErrorAlert(message: message)
        }
    }
    
    func present(lastWeekStatistics parameters: [Parameter], username: String,
                 andRelationType relationType: String) {
        var buttonType: ProfileButtonType
        switch relationType {
        case "followed":
            buttonType = .unfollow
        case "unrelated":
            buttonType = .follow
        case "self":
            buttonType = .settings
        default:
            return
        }
        let statistics = parameters.map({ $0.getCorrespondingStatistic() })
        DispatchQueue.main.async { [weak self] in
            self?.view.displayUsername(username)
            self?.view.displayLastWeekStatistics(statistics)
            self?.view.setActivityButtonType(buttonType)
            self?.isUserInfoPresented = true
            if let isUsernamePresented = self?.isUserInfoPresented, isUsernamePresented,
               let areRidesPresented = self?.areRidesPresented, areRidesPresented {
                self?.view.endLoading()
            }
        }
    }
    
    func presentButtonType(_ buttonType: ProfileButtonType) {
        DispatchQueue.main.async { [weak self] in
            self?.view.setActivityButtonType(buttonType)
            self?.view.endLoading()
        }
    }
    
    func presentRides(_ rides: [Ride]) {
        self.rides = rides
        DispatchQueue.main.async { [weak self] in
            self?.view.displayRides(rides)
            self?.areRidesPresented = true
            if let isUsernamePresented = self?.isUserInfoPresented, isUsernamePresented,
               let areRidesPresented = self?.areRidesPresented, areRidesPresented {
                self?.view.endLoading()
            }
        }
    }
    
    func presentRoute(_ route: [[CLLocationCoordinate2D]], forRideId rideId: Int) {
        for i in 0 ..< rides.count {
            if rides[i].id == rideId {
                rides[i].route = route
                DispatchQueue.main.async { [weak self] in
                    if let rides = self?.rides {
                        self?.view.displayRides(rides)
                    }
                }
            }
        }
    }
}
