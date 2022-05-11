//
//  UIViewExtensions.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

extension UIView {
    public func addCornerRadiusAndShadow() {
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.1
    }
}
