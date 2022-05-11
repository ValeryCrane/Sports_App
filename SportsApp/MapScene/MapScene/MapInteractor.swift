//
//  MapInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 18.04.2022.
//

import Foundation

protocol MapBusinessLogic: AnyObject { }

class MapInteractor {
    var presenter: MapPresentationLogic!
    private var worker: OptimizedLocationWorker
    
    init() {
        worker = OptimizedLocationWorker(kOfPrecision: 5)
        worker.addListener(self)
    }
    
    func startUpdating() {
        worker.startUpdatingLocation()
    }
}

extension MapInteractor: LocationListener {
    func didUpdate(altitude: Double) {
        presenter.present(altitude: altitude)
    }
    
    func didUpdate(speed: Double) {
        presenter.present(speed: speed)
    }
}

extension MapInteractor: MapBusinessLogic { }
