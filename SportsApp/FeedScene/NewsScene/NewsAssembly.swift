//
//  NewsAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

class NewsAssembly {
    func assemble() -> UIViewController {
        let view = NewsViewController()
        let interactor = NewsInteractor()
        let presenter = NewsPresenter()
        let router = NewsRouter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        view.router = router
        router.view = view
        
        return view
    }
}
