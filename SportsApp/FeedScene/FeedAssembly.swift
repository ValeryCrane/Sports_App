//
//  FeedAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

class FeedAssembly {
    func assemble() -> UIViewController {
        let view = FeedViewController()
        let interactor = FeedInteractor()
        let presenter = FeedPresenter()
        let router = FeedRouter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        view.router = router
        router.view = view
        
        return view
    }
}
