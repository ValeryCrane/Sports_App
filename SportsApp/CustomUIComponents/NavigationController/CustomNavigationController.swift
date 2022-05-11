//
//  CustomNavigationController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 17.04.2022.
//

import Foundation
import UIKit

// NavigationController with custom appearance.
class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Jura-Bold", size: 24)]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        navigationBar.tintColor = Colors.red
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationBar.layer.shadowRadius = 3
        navigationBar.layer.shadowOpacity = 0.1
        navigationBar.backgroundColor = Colors.gray2
    }
    
}
