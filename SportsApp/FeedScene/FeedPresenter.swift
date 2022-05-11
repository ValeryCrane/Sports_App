//
//  FeedPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import CoreLocation

protocol FeedPresentationLogic {
    func presentFeed(_ rides: [Ride])
    func presentRoute(_ route: [[CLLocationCoordinate2D]], forRideId rideId: Int)
    func presentError(message: String)
}

class FeedPresenter {
    weak var view: FeedDisplayLogic!
    private var rides = [Ride]()
}

extension FeedPresenter: FeedPresentationLogic {
    func presentFeed(_ rides: [Ride]) {
        self.rides = rides
        DispatchQueue.main.async { [weak view] in
            view?.displayFeed(rides)
        }
    }
    
    func presentError(message: String) {
        DispatchQueue.main.async { [weak view] in
            view?.displayErrorAlert(message: message)
        }
    }
    
    func presentRoute(_ route: [[CLLocationCoordinate2D]], forRideId rideId: Int) {
        for i in 0 ..< rides.count {
            if rides[i].id == rideId {
                rides[i].route = route
                DispatchQueue.main.async { [weak self] in
                    if let rides = self?.rides {
                        self?.view.displayFeed(rides)
                    }
                }
            }
        }
    }
    
    
}
