//
//  StartRecordRouter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 19.04.2022.
//

import Foundation
import UIKit

protocol StartRecordRoutingLogic: AnyObject {
    func routeToRecordScene(sportKind: SportKind)
    func routeToSportKindScene()
}

class StartRecordRouter {
    weak var view: (TouchTransparentViewController & StartRecordDisplayLogic)!
}

extension StartRecordRouter: StartRecordRoutingLogic {
    func routeToRecordScene(sportKind: SportKind) {
        let worker: SportWorkerLogic
        switch sportKind {
        case .running:
            worker = SimpleSportWorker()
        case .cycling:
            worker = CyclingWorker()
        case .skiing:
            worker = SimpleSportWorker()
        case .parachuting:
            worker = ParachutingWorker()
        }
        view.mapNavigationController?.setOverlayingViewController(RecordAssembly().assemble(worker: worker))
    }
    
    func routeToSportKindScene() {
        let sportKindViewController = SportKindViewContoller()
        sportKindViewController.startRecordView = view
        view.present(sportKindViewController, animated: true, completion: nil)
        
    }
}
