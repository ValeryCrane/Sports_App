//
//  SportKind.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation
import UIKit

enum SportKind: Int, CaseIterable {
    case running
    case cycling
    case skiing
    case parachuting
    
    public func getName() -> String {
        switch self {
        case .running:
            return "Running"
        case .cycling:
            return "Cycling"
        case .skiing:
            return "Skiing"
        case .parachuting:
            return "Parachuting"
        }
    }
    
    public func getImage() -> UIImage {
        switch self {
        case .running:
            return UIImage(named: "running")!
        case .cycling:
            return UIImage(named: "cycling")!
        case .skiing:
            return UIImage(named: "skiing")!
        case .parachuting:
            return UIImage(named: "parachuting")!
        }
    }
}
