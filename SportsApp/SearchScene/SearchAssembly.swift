//
//  SearchAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 07.05.2022.
//

import Foundation
import UIKit

class SearchAssembly {
    func assemble() -> UIViewController {
        let view = SearchViewController()
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        view.router = router
        router.view = view
        
        return view
    }
}
