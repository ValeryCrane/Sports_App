//
//  NewsCellModel.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

struct NewsCellModel {
    let id = UUID()
    let title: String
    let url: URL
    let imageUrl: URL
    var image: UIImage?
}
