//
//  SearchResult.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 07.05.2022.
//

import Foundation

struct SearchResult {
    let id: Int
    let name: String
    
    
    init?(fromJson json: [String: Any]) {
        if let id = json["id"] as? Int, let name = json["name"] as? String {
            self.id = id
            self.name = name
        } else {
            return nil
        }
    }
}
