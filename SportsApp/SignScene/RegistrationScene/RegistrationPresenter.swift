//
//  RegistrationPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation

import Foundation

protocol RegistrationPresentationLogic {
    func presentError(message: String)
    func presentSigned()
}

class RegistrationPresenter {
    weak var view: RegistrationDisplayLogic!
}

extension RegistrationPresenter: RegistrationPresentationLogic {
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
