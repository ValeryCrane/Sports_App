//
//  StaticticsPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 27.04.2022.
//

import Foundation

protocol StatisticsPresentationLogic: AnyObject {
    func presentTime(timeInSeconds: Int)
    func presentParameters(_ parameters: [Parameter])
}

class StatisticsPresenter {
    weak var view: StatisticsDisplayLogic!
}

extension StatisticsPresenter: StatisticsPresentationLogic {
    func presentTime(timeInSeconds: Int) {
        let seconds = timeInSeconds % 60
        let minutes = timeInSeconds / 60 % 60
        let hours = timeInSeconds / 3600
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
        DispatchQueue.main.async { [weak self] in
            self?.view.displayTime("\(hoursString):\(minutesString):\(secondsString)")
        }
    }
    
    func presentParameters(_ parameters: [Parameter]) {
        DispatchQueue.main.async { [weak self] in
            self?.view.displayStatistics(parameters.map( { $0.getCorrespondingStatistic() }))
        }
    }
}
