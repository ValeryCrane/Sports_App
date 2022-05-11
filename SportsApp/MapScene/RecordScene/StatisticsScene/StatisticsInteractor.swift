//
//  StatisticsInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 27.04.2022.
//

import Foundation

protocol StatisticsBusinessLogic: AnyObject {
    func update()
}

class StatisticsInteractor {
    var presenter: StatisticsPresentationLogic!
    private let sportWorker: SportWorkerLogic
    
    init(worker: SportWorkerLogic) {
        sportWorker = worker
        sportWorker.addListener(self)
    }
}

extension StatisticsInteractor: SportListener {
    func didUpdate(time: Int) {
        presenter.presentTime(timeInSeconds: time)
    }
    
    func didUpdate(parameters: [Parameter]) {
        presenter.presentParameters(parameters)
    }
}

extension StatisticsInteractor: StatisticsBusinessLogic {
    func update() {
        presenter.presentTime(timeInSeconds: sportWorker.time)
        presenter.presentParameters(sportWorker.parameters)
    }
}
