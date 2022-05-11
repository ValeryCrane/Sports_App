//
//  SignInPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation

protocol SignInPresentationLogic {
    func presentError(message: String)
    func presentSigned()
}

class SignInPresenter {
    weak var view: SignInDisplayLogic!
}

extension SignInPresenter: SignInPresentationLogic {
    func presentError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view.displayError(message: message)
        }
    }
    
    func presentSigned() {
        DispatchQueue.main.async { [weak self] in
            self?.view.signed()
        }
    }
}
