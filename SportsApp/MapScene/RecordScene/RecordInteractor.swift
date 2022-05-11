//
//  RecordInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 19.04.2022.
//

import Foundation
import CoreLocation
import MapKit

protocol RecordBusinessLogic {
    func startRecord()
    func pauseButtonPressed()
}

class RecordInteractor {
    var presenter: RecordPresentationLogic!
    
    private var paused = true
    private let sportWorker: SportWorkerLogic
    
    init(worker: SportWorkerLogic) {
        sportWorker = worker
        sportWorker.addListener(self)
    }
}

extension RecordInteractor: SportListener {
    func didUpdate(route: [[CLLocationCoordinate2D]]) {
        presenter.presentRoute(route.map({ MKPolyline(coordinates: $0, count: $0.count) }))
    }
}

extension RecordInteractor: RecordBusinessLogic {

    func startRecord() {
        paused = false
        sportWorker.start()
    }
    
    func pauseButtonPressed() {
        paused.toggle()
        if paused {
            sportWorker.stop()
            presenter.presentResumeButton()
        } else {
            sportWorker.start()
            presenter.presentPauseButton()
        }
    }

}
