//
//  Distance.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation

class Distance {
    private let meters: Double
    private let feature: String
    
    init(feature: String, meters: Double) {
        self.feature = feature
        self.meters = meters
    }
}

extension Distance: Parameter {
    func getCorrespondingStatistic() -> Statistic {
        if meters < 100 {
            return Statistic(feature: feature, value: meters, unit: "m")
        }
        return Statistic(feature: feature, value: meters / 1000, unit: "km")
    }
    
    func getValueInSI() -> Double {
        return meters
    }
    
    func getFeature() -> String {
        return feature
    }
}
