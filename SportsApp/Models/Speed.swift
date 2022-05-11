//
//  Speed.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation

class Speed {
    private let metersPerSecond: Double
    private let feature: String
    
    init(feature: String, metersPerSecond: Double) {
        self.feature = feature
        self.metersPerSecond = metersPerSecond
    }
}

extension Speed: Parameter {
    func getCorrespondingStatistic() -> Statistic {
        return Statistic(feature: feature,
                         value: metersPerSecond * 3600 / 1000,
                         unit: "km/h")
    }
    
    func getValueInSI() -> Double {
        return metersPerSecond
    }
    
    func getFeature() -> String {
        return feature
    }
}
