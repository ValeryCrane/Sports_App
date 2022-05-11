//
//  FinishRecordRouter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol FinishRecordRoutingLogic {
    func restartRecord()
}

class FinishRecordRouter {
    weak var mapViewController: MapDisplayLogic!
    weak var view: UIViewController!
}

extension FinishRecordRouter: FinishRecordRoutingLogic {
    func restartRecord() {
        mapViewController.setOverlayingViewController(StartRecordAssembly().assemble())
        view.navigationController?.popViewController(animated: true)
    }
}
