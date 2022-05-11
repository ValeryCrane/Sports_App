//
//  TouchTransparentScrollView.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 18.04.2022.
//

import Foundation
import UIKit

class TouchTransparentScrollView: UIScrollView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitTestView = super.hitTest(point, with: event),
              hitTestView != self
        else { return nil }
        return hitTestView
    }
}
