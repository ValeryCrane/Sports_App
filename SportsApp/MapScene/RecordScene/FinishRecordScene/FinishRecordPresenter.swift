//
//  FinishRecordPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation

protocol FinishRecordPresentationLogic {
    func presentError(message: String)
    func restartRecord()
}

class FinishRecordPresenter {
    weak var view: FinishRecordDisplayLogic!
}

extension FinishRecordPresenter: FinishRecordPresentationLogic {
    func presentError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view.displayError(message: message)
        }
    }
    
    func restartRecord() {
        DispatchQueue.main.async {  [weak self] in
            self?.view.restartRecord()
        }
    }
    
    
}
