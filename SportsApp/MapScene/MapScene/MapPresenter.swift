//
//  MapPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 18.04.2022.
//

import Foundation

protocol MapPresentationLogic: AnyObject {
    func present(altitude: Double)
    func present(speed: Double)
}

class MapPresenter {
    weak var view: MapDisplayLogic!
}

extension MapPresenter: MapPresentationLogic {
    func present(altitude: Double) {
        let altitudeInMeters = Int(altitude.rounded())
        view.display(altitude: "\(altitudeInMeters)m")
    }
    
    func present(speed: Double) {
        if speed < 10 {
            view.display(speed: String(format: "%.1f", speed) + "km/h")
        } else {
            let speedInKmh = Int(speed.rounded())
            view.display(speed: "\(speedInKmh)km/h")
        }
    }
}
