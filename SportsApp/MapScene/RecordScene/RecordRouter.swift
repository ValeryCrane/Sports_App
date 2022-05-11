//
//  RecordRouter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 26.04.2022.
//

import Foundation
import UIKit

protocol RecordRoutingLogic: AnyObject {
    func routeToStatistics()
    func routeToFinishRecordScene()
}

class RecordRouter {
    weak var view: TouchTransparentViewController!
    private let sportWorker: SportWorkerLogic
    init(worker: SportWorkerLogic) {
        sportWorker = worker
    }
}

extension RecordRouter: RecordRoutingLogic {
    func routeToStatistics() {
        view.navigationController?.pushViewController(
            StatisticsAssembly().assemble(worker: sportWorker), animated: true)
    }
    
    func routeToFinishRecordScene() {
        guard let mapViewController = view.mapNavigationController else { return }
        view.navigationController?.pushViewController(
            FinishRecordAssembly().assemble(mapViewController: mapViewController, worker: sportWorker), animated: true)
    }
}
