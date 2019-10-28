//
//  LocationService.swift
//  Komoot
//
//  Created by Ani Eduard on 28/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import CoreLocation

final class LocationService: NSObject {
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    
    private let locationManager: CLLocationManager
    
    // MARK: - Init
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private var previousLocation: CLLocation?
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let location = locations.last else { return }
        
        print(String(describing: previousLocation))
        print(location.coordinate.latitude, location.coordinate.longitude)
        
        let distance = previousLocation?.distance(from: location) ?? 0
        
        previousLocation = location
        
        guard distance >= 100 else { return }
        
        print("DISTANCE:", "\(Int(distance))m")
    }
}
