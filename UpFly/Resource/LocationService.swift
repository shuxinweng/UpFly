//
//  LocationService.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/7/23.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    private var locationUpdatedHandlers: [(CLLocationCoordinate2D) -> Void] = []
    
    override private init() {
        super.init()
        self.requestPermissionToAccessLocation()
    }
    
    func addLocationUpdatedHandler(_ handler: @escaping (CLLocationCoordinate2D) -> Void) {
        locationUpdatedHandlers.append(handler)
    }
    
    func requestPermissionToAccessLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            print("Error with location authorization")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
//            locationManager.stopUpdatingLocation()
            locationUpdatedHandlers.forEach { $0(location) }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
