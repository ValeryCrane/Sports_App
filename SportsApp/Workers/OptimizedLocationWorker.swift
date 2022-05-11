//
//  OptimizedLocationWorker.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 18.04.2022.
//

import Foundation
import CoreLocation


protocol LocationListener: AnyObject {
    func didUpdate(location: CLLocation)                    // Notifies about location updates.
    func didUpdate(speed: Double)                           // Notifies about speed updates.
    func needsAuthorization()                               // Notifies about lack of authorization.
    func authorizationGranted()                             // Notifies about gain of authorization.
}


// This makes OptimizedLocationListener methods optional.
extension LocationListener {
    func didUpdate(location: CLLocation) { }
    func didUpdate(speed: Double) { }
    func needsAuthorization() { }
    func authorizationGranted() { }
}


// This class notifies about any significant location changes and manages authorization.
final class OptimizedLocationWorker: NSObject {
    private var listeners: [() -> LocationListener?] = []
    private var kOfPrecision: Int
    private var numberOfProcessedLocations = 0
    
    private var locationManager = CLLocationManager()
    private var previousLocations: Set<CLLocation> = []
    private var isWaitingForAuthorization = false
    
    init(kOfPrecision: Int) {
        self.kOfPrecision = kOfPrecision
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    // MARK: - Public functions
    // Adds listener for location updates.
    func addListener(_ listener: LocationListener) {
        listeners.append({ [weak listener] in
            return listener
        })
    }
    
    // Starts location updates.
    func startUpdatingLocation() {
        if locationManager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            isWaitingForAuthorization = true
            processLocationManagerAuthorization()
        }
    }
    
    // Stops location updates.
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Processing functions
    // Processes user interactions with location authorization.
    private func processLocationManagerAuthorization() {
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            print("Location is not permitted!")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            if isWaitingForAuthorization {
                locationManager.startUpdatingLocation()
                isWaitingForAuthorization = false
            }
        @unknown default:
            print("Unknown location case")
        }
    }
    
    // Processes new locations (their coordinates).
    private func processLocation(_ location: CLLocation) {
        numberOfProcessedLocations += 1
        
        var hasLeavedCurrentRegion = false
        
        for previousLocation in previousLocations {
            if location.distance(from: previousLocation) > location.horizontalAccuracy ||
               abs(previousLocation.altitude - location.altitude) > location.verticalAccuracy {
                hasLeavedCurrentRegion = true
                previousLocations.remove(previousLocation)
            }
        }
        previousLocations.insert(location)
        removeRedundantLocations()
        
        var sumOfLatitudes: Double = 0.0
        var sumOfLongitudes: Double = 0.0
        var sumOfAltitudes: Double = 0.0
        
        for previousLocation in previousLocations {
            sumOfLatitudes += previousLocation.coordinate.latitude
            sumOfLongitudes += previousLocation.coordinate.longitude
            sumOfAltitudes += previousLocation.altitude
        }
        
        let averageLatitude = sumOfLatitudes / Double(previousLocations.count)
        let averageLongitude = sumOfLongitudes / Double(previousLocations.count)
        let averageAltitude = sumOfAltitudes / Double(previousLocations.count)
        
        if numberOfProcessedLocations == kOfPrecision || hasLeavedCurrentRegion {
            for listener in listeners.compactMap({ $0() }) {
                listener.didUpdate(location: CLLocation(
                    coordinate: CLLocationCoordinate2D(latitude: averageLatitude,
                                                       longitude: averageLongitude),
                    altitude: averageAltitude,
                    horizontalAccuracy: 0,
                    verticalAccuracy: 0,
                    timestamp: Date()
                ))
            }
        }
    }
    
    // Processes new speed values
    private func processSpeed(_ speed: Double) {
        let correctSpeed = (speed < 0.0) ? 0.0 : speed
        for listener in listeners.compactMap({ $0() }) {
            listener.didUpdate(speed: correctSpeed)
        }
    }
    
    // Removes locations with least horizontal accuracy in order to make
    // size of array of previous locations equal kOfPrecision.
    private func removeRedundantLocations() {
        while previousLocations.count > kOfPrecision {
            guard var leastHorizontalAccuracyLocation = previousLocations.first else { break }
            for previousLocation in previousLocations {
                if leastHorizontalAccuracyLocation.horizontalAccuracy > previousLocation.horizontalAccuracy {
                    leastHorizontalAccuracyLocation = previousLocation
                }
            }
            previousLocations.remove(leastHorizontalAccuracyLocation)
        }
    }
}


// MARK: - CLLocationManagerDelegate implementation.
extension OptimizedLocationWorker: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        processLocationManagerAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            processLocation(location)
            processSpeed(location.speed)
        }
    }
    
    // Converts meters per second to kilometers per hour.
    private func mpsToKmh(speed: Double) -> Double {
        return speed * 3600 / 1000
    }
}
