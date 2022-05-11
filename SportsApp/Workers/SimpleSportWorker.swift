//
//  SimpleSportWorker.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation
import CoreLocation

class SimpleSportWorker: SportWorkerLogic {
    private static let sharedWorker = SimpleSportWorker()
    public class func shared() -> SportWorkerLogic {
        return sharedWorker
    }
    
    private var timeWorker = TimeWorker()
    private let locationWorker = OptimizedLocationWorker(kOfPrecision: 5)
    
    private let minSegmentPointLength = 10
    private var listeners = [() -> SportListener?]()
    private(set) var routeWithAltitudes = [[CLLocation]]() {
        didSet {
            for listener in listeners.map({ $0() }) {
                listener?.didUpdate(route: route)
                listener?.didUpdate(parameters: parameters)
            }
        }
    }
    
    public init() {
        timeWorker.addListener(self)
        locationWorker.addListener(self)
    }
    
    public var time: Int {
        return timeWorker.time
    }
    
    public var route: [[CLLocationCoordinate2D]] {
        return routeWithAltitudes.map({ $0.map({ $0.coordinate }) })
    }
    
    public var parameters: [Parameter] {
        return [
            Distance(feature: "distance", meters: getDistanceInMeters()),
            Speed(feature: "avg. speed", metersPerSecond: getAverageSpeedInMps())
        ]
    }
    
    public func addListener(_ listener: SportListener) {
        listeners.append({ [weak listener] in
            return listener
        })
    }
    
    public func start() {
        routeWithAltitudes.append([CLLocation]())
        locationWorker.startUpdatingLocation()
        timeWorker.start()
    }
    
    public func stop() {
        locationWorker.stopUpdatingLocation()
        timeWorker.pause()
        if routeWithAltitudes[routeWithAltitudes.endIndex - 1].count < minSegmentPointLength {
            routeWithAltitudes.removeLast()
        }
    }
    
    public func clear() {
        timeWorker = TimeWorker()
        routeWithAltitudes = [[CLLocation]]()
    }
    
    private func getDistanceInMeters() -> Double {
        var meters = 0.0
        for segment in routeWithAltitudes {
            guard segment.count > 1 else { continue }
            for idx in 0 ..< segment.count - 1 {
                meters += sqrt(
                    pow(segment[idx].distance(from: segment[idx + 1]), 2) +
                    pow(segment[idx].altitude - segment[idx + 1].altitude, 2)
                )
            }
        }
        return meters
    }
    
    private func getAverageSpeedInMps() -> Double {
        guard time != 0 else { return 0 }
        return getDistanceInMeters() / Double(time)
    }
    
    func getJsonParameters() -> [String: Any] {
        var jsonParameters = [String: Any]()
        for parameter in parameters {
            jsonParameters[parameter.getFeature()] = parameter.getValueInSI()
        }
        return jsonParameters
    }
    
    func getJsonRoute() -> [Any] {
        return route.map({ $0.map({ coordinate -> [String: Any] in
            let jsonCoordinate: [String: Any] = [
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude
            ]
            return jsonCoordinate
        })})
    }
    
    
    func getSportKind() -> SportKind {
        return SportKind.running
    }
    
}

extension SimpleSportWorker: TimeListener {
    func didUpdate(time: Int) {
        for listener in listeners.map({ $0() }) {
            listener?.didUpdate(time: time)
            listener?.didUpdate(parameters: parameters)
        }
    }
}

extension SimpleSportWorker: LocationListener {
    func didUpdate(location: CLLocation) {
        routeWithAltitudes[routeWithAltitudes.endIndex - 1].append(location)
    }
}

