//
//  TouchTransparentViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 16.04.2022.
//

import Foundation
import UIKit

class TouchTransparentViewController: UIViewController {
    var mapNavigationController: MapDisplayLogic? {
        if let touchTransparentParent = self.parent as? TouchTransparentViewController {
            return touchTransparentParent.mapNavigationController
        } else if let mapNavigationParent = self.parent as? MapDisplayLogic {
            return mapNavigationParent
        } else {
            return nil
        }
    }
    
    override func loadView() {
        view = TouchTransparentView()
    }
}
