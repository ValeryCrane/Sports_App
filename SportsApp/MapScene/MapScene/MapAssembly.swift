//
//  MapAssembly.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 18.04.2022.
//

import Foundation
import UIKit

class MapAssembly {
    func assemble() -> UIViewController {
        let view = MapViewController()
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        
        interactor.startUpdating()
        
        return view
    }
}
