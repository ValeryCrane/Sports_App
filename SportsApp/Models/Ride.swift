//
//  Ride.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation
import CoreLocation

struct Ride {
    let id: Int
    let username: String
    let name: String
    let description: String
    let sport: String               // TODO: - Make SportKind
    let parameters: [Parameter]
    var route: [[CLLocationCoordinate2D]]?
    
    init?(fromJson json: [String: Any]) {
        if let id = json["id"] as? Int,
           let username = json["username"] as? String,
           let name = json["name"] as? String,
           let description = json["description"] as? String,
           let sport = json["sport"] as? String,
           let statistics = json["statistics"] as? [String: Any] {
            
            self.id = id
            self.username = username
            self.name = name
            self.description = description
            self.sport = sport
            
            var parameters = [Parameter]()
            for statistic in statistics {
                guard
                    let value = statistic.value as? Double,
                    let parameter = Speed.getParameter(feature: statistic.key, value: value)
                else { return nil }
                parameters.append(parameter)
            }
            self.parameters = parameters
            
        } else { return nil }
    }
}
