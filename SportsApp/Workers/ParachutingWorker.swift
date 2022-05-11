//
//  ParachutingWorker.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation

class ParachutingWorker: SimpleSportWorker {
    private static let sharedWorker = ParachutingWorker()
    public override static func shared() -> SportWorkerLogic {
        return sharedWorker
    }
    
    override var parameters: [Parameter] {
        var result = super.parameters
        result.append(Speed(feature: "avg. v. speed", metersPerSecond: getAverageVerticalSpeed()))
        return result
    }
    
    private func getAverageVerticalSpeed() -> Double {
        var minAltitude: Double?
        var maxAltitude: Double?
        for segment in routeWithAltitudes {
            for location in segment {
                if minAltitude == nil {
                    minAltitude = location.altitude
                } else {
                    minAltitude = min(minAltitude!, location.altitude)
                }
                if maxAltitude == nil {
                    maxAltitude = location.altitude
                } else {
                    maxAltitude = max(maxAltitude!, location.altitude)
                }
            }
        }
        if let minAltutude = minAltitude, let maxAltitude = maxAltitude, time != 0 {
            return (maxAltitude - minAltutude) / Double(time)
        } else {
            return 0.0
        }

    }
    
    override func getSportKind() -> SportKind {
        return SportKind.parachuting
    }
}
