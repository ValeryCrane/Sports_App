//
//  SignInRouter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol SignInRoutingLogic {
    func routeToRegistrationScene()
    func routeToApp()
}

class SignInRouter {
    weak var view: UIViewController!
    weak var signDelegate: SignDelegate!
}

extension SignInRouter: SignInRoutingLogic {
    func routeToRegistrationScene() {
        view.navigationController?.pushViewController(
            RegistrationAssembly().assemble(signDelegate: signDelegate), animated: true)
    }
    
    func routeToApp() {
        signDelegate.openApp()
    }
    
}
