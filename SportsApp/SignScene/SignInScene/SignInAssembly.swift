//
//  SignInAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

class SignInAssembly {
    public func assemble(signDelegate: SignDelegate) -> UIViewController {
        let view = SignInViewController()
        let interactor = SignInInteractor()
        let presenter = SignInPresenter()
        let router = SignInRouter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        view.router = router
        router.view = view
        router.signDelegate = signDelegate
        
        return view
    }
}
