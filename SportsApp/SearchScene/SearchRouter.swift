//
//  SearchRouter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 07.05.2022.
//

import Foundation
import UIKit

protocol SearchRoutingLogic {
    func routeToProfile(userId: Int)
}

class SearchRouter {
    weak var view: UIViewController!
}

extension SearchRouter: SearchRoutingLogic {
    func routeToProfile(userId: Int) {
        let profileView = ProfileAssembly().assemble(userId: userId)
        view.navigationController?.pushViewController(profileView, animated: true)
    }
    
}
