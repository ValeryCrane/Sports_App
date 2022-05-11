//
//  CyclingWorker.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation

class CyclingWorker: SimpleSportWorker {
    private static let sharedWorker = ParachutingWorker()
    public override static func shared() -> SportWorkerLogic {
        return sharedWorker
    }
    
    override var parameters: [Parameter] {
        var result = super.parameters
        result.append(Distance(feature: "elevation", meters: getElevation()))
        return result
    }
    
    private func getElevation() -> Double {
        var elevation = 0.0
        for segment in routeWithAltitudes {
            guard segment.count >= 2 else { continue }
            for i in 0 ..< segment.count - 1 {
                if segment[i + 1].altitude > segment[i].altitude {
                    elevation += segment[i + 1].altitude - segment[i].altitude
                }
            }
        }
        return elevation
    }
    
    override func getSportKind() -> SportKind {
        SportKind.cycling
    }
}
