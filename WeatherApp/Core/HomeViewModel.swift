//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 21/08/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import CoreLocation
import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func startSearchFlow()
    func startWeatherFlowForCurrentLocation(_ currentLocation: Location)
}

class HomeViewModel {
    private let currentLocationProvider: CurrentLocationProvider
    weak var coordinatorDelegate: HomeViewModelDelegate?
    var locations: [LocationModel]

    init(currentLocationProvider: CurrentLocationProvider,
         locations: [LocationModel] = []) {
        self.currentLocationProvider = currentLocationProvider
        self.locations = locations
    }

    func requestLocationAuthorisation() {
        currentLocationProvider.requestWhenInUseAuthorisation()
    }

    func didTapSearch() {
        coordinatorDelegate?.startSearchFlow()
    }

    func didTapLocation(onFailure: @escaping (_ locationDisabled: Bool, _ withError: Error?) -> ()) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocationProvider.getCurrentLocation { [weak self] result in
                switch result {
                case .success(let location):
                    self?.coordinatorDelegate?.startWeatherFlowForCurrentLocation(location)
                case .failure(let error):
                    onFailure(false, error)
                }
            }
        case .notDetermined:
            currentLocationProvider.requestWhenInUseAuthorisation()
            onFailure(false, nil)
        case .restricted, .denied:
            onFailure(true, nil)
        @unknown default:
            fatalError("Unhandled authorizationStatus")
        }
    }
}
