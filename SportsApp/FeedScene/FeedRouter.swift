//
//  FeedRouter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol FeedRoutingLogic {
    func routeToNews()
}

class FeedRouter {
    weak var view: UIViewController!
}

extension FeedRouter: FeedRoutingLogic {
    func routeToNews() {
        let newsView = NewsAssembly().assemble()
        view.navigationController?.pushViewController(newsView, animated: true)
    }
}
