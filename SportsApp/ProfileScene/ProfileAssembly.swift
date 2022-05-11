//
//  ProfileAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation
import UIKit

class ProfileAssembly {
    func assemble() -> UIViewController {
        let view = ProfileViewController()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        
        return view
    }
    
    func assemble(userId: Int) -> UIViewController {
        let view = ProfileViewController()
        let interactor = ProfileInteractor(userId: userId)
        let presenter = ProfilePresenter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        
        return view
    }
}
