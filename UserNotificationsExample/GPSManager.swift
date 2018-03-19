//
//  GPSManager.swift
//  UserNotificationsExample
//
//  Created by Oscar Peredo on 2018/03/13.
//  Copyright © 2018 Fenrir. All rights reserved.
//

import Foundation

import CoreLocation

class GPSManager: NSObject {
    
    var latitude : NSNumber?
    var longitude : NSNumber?
    
    lazy var locationManager : CLLocationManager = {
        return CLLocationManager.init()
    } ()
    
    static let shared = GPSManager()
    private override init() {
        super.init()
    }
    
    
    func startStandardUpdates() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        // Set a movement threshold for new events (in meters)
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // User has not yet made a choice with regards to this application
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusNotDetermined")
            
            locationManager.requestWhenInUseAuthorization()
            
            break
            
        case .restricted:
            // This application is not authorized to use location services.  Due
            // to active restrictions on location services, the user cannot change
            // this status, and may not have personally denied authorization
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusRestricted")
            
            break
            
        case .denied:
            // User has explicitly denied authorization for this application, or
            // location services are disabled in Settings.
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusDenied")
            
            break
            
        case .authorizedAlways:
            // User has granted authorization to use their location at any time,
            // including monitoring for regions, visits, or significant location changes.
            //
            // This value should be used on iOS, tvOS and watchOS.  It is available on
            // MacOS, but kCLAuthorizationStatusAuthorized is synonymous and preferred.
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusAuthorizedAlways");
            
            locationManager.startUpdatingLocation()
            print("GPSManager: Location updates started.")
            
            break
            
        case .authorizedWhenInUse:
            // User has granted authorization to use their location only when your app
            // is visible to them (it will be made visible to them if you continue to
            // receive location updates while in the background).  Authorization to use
            // launch APIs has not been granted.
            //
            // This value is not available on MacOS.  It should be used on iOS, tvOS and
            // watchOS.
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusAuthorizedWhenInUse")
            
            locationManager.startUpdatingLocation()
            print("GPSManager: Location updates started.")
            
            break;
        }
    }
    
    func stopStandardUpdates()
    {
        locationManager.stopUpdatingLocation()
        
        latitude = nil
        longitude = nil
        
        print("GPSManager: Location updates stopped and location data nilled.")
    }
    
    func enableBackgroundUpdates()
    {
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func disableBackgroundUpdates()
    {
        locationManager.allowsBackgroundLocationUpdates = false
    }
}

extension GPSManager : CLLocationManagerDelegate {
    
    /*
     *  locationManager:didUpdateLocations:
     *
     *  Discussion:
     *    Invoked when new locations are available.  Required for delivery of
     *    deferred locations.  If implemented, updates will
     *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
     *
     *    locations is an array of CLLocation objects in chronological order.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // A location must exist and be within 15 seconds from now (to avoid getting the last location the gps registered before being started).
        guard let location = locations.last, fabs(location.timestamp.timeIntervalSinceNow) < 15.0 else {
            return
        }
        
        latitude = NSNumber(value: location.coordinate.latitude)
        longitude = NSNumber(value: location.coordinate.longitude)
    }
    
    /*
     *  locationManager:didFailWithError:
     *
     *  Discussion:
     *    Invoked when an error has occurred. Error types are defined in "CLError.h".
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("GPSManager: Did fail with error \(error.localizedDescription).")
    }
    
    /*
     *  locationManager:didChangeAuthorizationStatus:
     *
     *  Discussion:
     *    Invoked when the authorization status changes for this application.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("GPSManager: Authorization Status Changed")
        
        switch (status) {
        case .notDetermined:
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusNotDetermined")
            break
        case .restricted:
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusRestricted")
            break
        case .denied:
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusDenied")
            break
        case .authorizedAlways:
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusAuthorizedAlways")
            locationManager.startUpdatingLocation()
            NSLog("GPSManager: Location updates started.");
            break
        case .authorizedWhenInUse:
            print("GPSManager: Authorization Status ->  kCLAuthorizationStatusAuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
            print("GPSManager: Location updates started.")
            break
        }
        
    }
}

