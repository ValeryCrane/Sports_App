//
//  RegistrationAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

class RegistrationAssembly {
    func assemble(signDelegate: SignDelegate) -> UIViewController {
        let view = RegistrationViewController()
        let interactor = RegistrationInteractor()
        let presenter = RegistrationPresenter()
        let router = RegistrationRouter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        view.router = router
        router.view = view
        router.signDelegate = signDelegate
        
        return view
    }
}
