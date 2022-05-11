//
//  Parameter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation

protocol Parameter: AnyObject {
    func getCorrespondingStatistic() -> Statistic
    func getValueInSI() -> Double
    func getFeature() -> String
}

extension Parameter {
    public static func getParameter(feature: String, value: Double) -> Parameter? {
        switch feature {
        case "avg. speed":
            return Speed(feature: "avg. speed", metersPerSecond: value)
        case "distance":
            return Distance(feature: "distance", meters: value)
        case "elevation":
            return Distance(feature: "elevation", meters: value)
        case "avg. v. speed":
            return Speed(feature: "avg. v. speed", metersPerSecond: value)
        default:
            return nil
        }
    }
}
