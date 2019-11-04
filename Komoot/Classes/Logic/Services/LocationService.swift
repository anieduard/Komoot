//
//  LocationService.swift
//  Komoot
//
//  Created by Ani Eduard on 28/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func userDidPassThreshold(with coordinate: CLLocationCoordinate2D)
}

final class LocationService: NSObject {
    
    // MARK: - Public properties
    
    weak var delegate: LocationServiceDelegate?
    
    // MARK: - Private properties
    
    private let locationManager: CLLocationManager
    private var lastKnownLocation: CLLocation?
    
    // MARK: - Init
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = .distanceThreshold
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Logic
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let distance = lastKnownLocation?.distance(from: location) ?? 0
        lastKnownLocation = location
        
        guard distance >= .distanceThreshold else { return }
        delegate?.userDidPassThreshold(with: location.coordinate)
    }
}

// MARK: - Constants

private extension CLLocationDistance {
    static let distanceThreshold: CLLocationDistance = 100
}
