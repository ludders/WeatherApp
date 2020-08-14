//
//  CurrentLocationProvider.swift
//  WeatherApp
//
//  Created by dludlow7 on 06/08/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import CoreLocation
import Foundation

typealias CurrentLocationCompletion = (Result<Location, Error>) -> ()

class CurrentLocationProvider: NSObject {
    private let locationManager: CLLocationManager
    private var currentLocationCompletion: CurrentLocationCompletion?

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        locationManager.desiredAccuracy = 5000
        super.init()
        locationManager.delegate = self
    }

    func getCurrentLocation(onCompletion completion: @escaping CurrentLocationCompletion) {
        currentLocationCompletion = completion
        locationManager.requestLocation()
    }

    func requestWhenInUseAuthorisation() {
        locationManager.requestWhenInUseAuthorization()
    }
}

//MARK: - CLLocationManager Delegate Functions

extension CurrentLocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let recievedLocation = locations.last else { return }
        let location = Location(name: NSLocalizedString("Current Location", comment: "Current Location"),
                                coordinates: recievedLocation.coordinate)
        currentLocationCompletion?(.success(location))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocationCompletion?(.failure(error))
    }
}
