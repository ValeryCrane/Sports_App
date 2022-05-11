//
//  SportWorkerLogic.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation
import CoreLocation

protocol SportWorkerLogic: AnyObject {
    var time: Int { get }
    var parameters: [Parameter] { get }
    var route: [[CLLocationCoordinate2D]] { get }
    func getJsonParameters() -> [String: Any]
    func getJsonRoute() -> [Any]
    func getSportKind() -> SportKind
    func addListener(_ listener: SportListener)
    func start()
    func clear()
    func stop()
}

protocol SportListener: AnyObject {
    func didUpdate(time: Int)
    func didUpdate(parameters: [Parameter])
    func didUpdate(route: [[CLLocationCoordinate2D]])
}

extension SportListener {
    func didUpdate(time: Int) { }
    func didUpdate(parameters: [Parameter]) { }
    func didUpdate(route: [[CLLocationCoordinate2D]]) { }
}
