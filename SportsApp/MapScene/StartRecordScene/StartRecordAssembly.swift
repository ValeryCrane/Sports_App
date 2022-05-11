//
//  StartRecordAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 19.04.2022.
//

import Foundation
import UIKit


class StartRecordAssembly {
    func assemble() -> TouchTransparentViewController {
        let view = StartRecordViewController()
        let router = StartRecordRouter()
        
        view.router = router
        router.view = view
        
        return view
    }
}
