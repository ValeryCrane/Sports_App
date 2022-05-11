//
//  FinishRecordAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation
import UIKit

class FinishRecordAssembly {
    func assemble(mapViewController: MapDisplayLogic, worker: SportWorkerLogic) -> UIViewController {
        let view = FinishRecordViewController()
        let interactor = FinishRecordInteractor(worker: worker)
        let presenter = FinishRecordPresenter()
        let router = FinishRecordRouter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        view.router = router
        router.view = view
        router.mapViewController = mapViewController
        
        return view
    }
}
