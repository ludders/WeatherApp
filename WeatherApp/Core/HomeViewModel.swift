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
    func startSearchFlow(selectionDelegate: SearchSelectionDelegate?)
    func showWeather(for location: Location)
}

class HomeViewModel {
    private let deviceLocationProvider: DeviceLocationProvider
    weak var coordinatorDelegate: HomeViewModelDelegate?
    init(deviceLocationProvider: DeviceLocationProvider) {
        self.deviceLocationProvider = deviceLocationProvider
    }

    func requestLocationAuthorisation() {
        deviceLocationProvider.requestWhenInUseAuthorisation()
    }

    func didTapSearch(selectionDelegate: SearchSelectionDelegate?) {
        coordinatorDelegate?.startSearchFlow(selectionDelegate: selectionDelegate)
    }

    func didTapLocation(onFailure: @escaping (_ locationDisabled: Bool, _ withError: Error?) -> ()) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            deviceLocationProvider.getDeviceLocation { [weak self] result in
                switch result {
                case .success(let deviceLocation):
                    self?.coordinatorDelegate?.showWeather(for: deviceLocation)
                case .failure(let error):
                    onFailure(false, error)
                }
            }
        case .notDetermined:
            deviceLocationProvider.requestWhenInUseAuthorisation()
            onFailure(false, nil)
        case .restricted, .denied:
            onFailure(true, nil)
        @unknown default:
            fatalError("Unhandled authorizationStatus")
        }
    }

    func didTapMenu() {
        
    }

    func didTapImage() {
        //For debugging stuff
    }
}
