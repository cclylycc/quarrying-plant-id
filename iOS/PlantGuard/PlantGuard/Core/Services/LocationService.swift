//
//  LocationService.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation
import CoreLocation

@Observable
@MainActor
class LocationService {
    static let shared = LocationService()
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var currentLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
    private var delegate: LocationDelegate?
    
    init() {
        delegate = LocationDelegate { [weak self] location in
            Task { @MainActor in
                self?.currentLocation = location
            }
        } authorizationChanged: { [weak self] status in
            Task { @MainActor in
                self?.authorizationStatus = status
            }
        }
        
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestPermission()
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

private class LocationDelegate: NSObject, CLLocationManagerDelegate {
    let onLocationUpdate: (CLLocation) -> Void
    let onAuthorizationChanged: (CLAuthorizationStatus) -> Void
    
    init(onLocationUpdate: @escaping (CLLocation) -> Void, authorizationChanged: @escaping (CLAuthorizationStatus) -> Void) {
        self.onLocationUpdate = onLocationUpdate
        self.onAuthorizationChanged = authorizationChanged
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            onLocationUpdate(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onAuthorizationChanged(status)
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

