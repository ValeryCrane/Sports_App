//
//  RegistrationRouter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol RegistrationRoutingLogic {
    func routeToApp()
}

class RegistrationRouter {
    weak var view: UIViewController!
    weak var signDelegate: SignDelegate!
}

extension RegistrationRouter: RegistrationRoutingLogic {
    func routeToApp() {
        signDelegate.openApp()
    }
    
}
