//
//  RecordAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 20.04.2022.
//

import Foundation
import UIKit

class RecordAssembly {
    func assemble(worker: SportWorkerLogic) -> TouchTransparentViewController {
        let view = RecordViewController()
        let interactor = RecordInteractor(worker: worker)
        let presenter = RecordPresenter()
        let router = RecordRouter(worker: worker)
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        view.router = router
        router.view = view
        
        return view
    }
}
