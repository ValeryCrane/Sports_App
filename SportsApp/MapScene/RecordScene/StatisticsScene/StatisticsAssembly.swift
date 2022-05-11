//
//  StatisticsAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 27.04.2022.
//

import Foundation
import UIKit

class StatisticsAssembly {
    func assemble(worker: SportWorkerLogic) -> UIViewController {
        let view = StatisticsViewController()
        let interactor = StatisticsInteractor(worker: worker)
        let presenter = StatisticsPresenter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        
        return view
    }
}
