//
//  RecordPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 20.04.2022.
//

import Foundation
import MapKit

protocol RecordPresentationLogic {
    func presentRoute(_ polylines: [MKPolyline])
    func presentPauseButton()
    func presentResumeButton()
    func present(distance: Double)
}

class RecordPresenter {
    weak var view: RecordDisplayLogic!
    private var previousPolylines = [MKPolyline]()
}

extension RecordPresenter: RecordPresentationLogic {
    func presentRoute(_ polylines: [MKPolyline]) {
        DispatchQueue.main.async { [weak self] in
            guard let previousPolylines = self?.previousPolylines else { return }
            for previousPolyline in previousPolylines {
                self?.view.mapNavigationController?.removePolyline(previousPolyline)
            }
            for polyline in polylines {
                self?.view.mapNavigationController?.addPolyline(polyline)
            }
            self?.previousPolylines = polylines
        }
    }
    
    func presentPauseButton() {
        DispatchQueue.main.async { [weak self] in
            self?.view.displayPauseButton()
        }
    }
    
    func presentResumeButton() {
        DispatchQueue.main.async { [weak self] in
            self?.view.displayResumeButton()
        }
    }
    
    func present(distance: Double) {
        guard distance >= 0.0 else { return }
        DispatchQueue.main.async { [weak self] in
            if distance < 1000 {
                self?.view.display(distance: "\(Int(distance.rounded()))m")
            } else {
                self?.view.display(distance: String(format: "%.1f", distance) + "km")
            }
        }
    }
}
