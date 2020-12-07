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
    func startSearchFlow(delegate: LocationSelectionDelegate?)
    func startMenuFlow()
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

    func didTapSearch(selectionDelegate: LocationSelectionDelegate?) {
        coordinatorDelegate?.startSearchFlow(delegate: selectionDelegate)
    }

    func didTapLocation(onSuccess: @escaping (Location) -> (),
                        onDisabled: @escaping () -> (),
                        onError: @escaping (Error) -> ()) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            deviceLocationProvider.getDeviceLocation { result in
                switch result {
                case .success(let deviceLocation):
                    onSuccess(deviceLocation)
                case .failure(let error):
                    onError(error)
                }
            }
        case .notDetermined:
            deviceLocationProvider.requestWhenInUseAuthorisation()
        case .restricted, .denied:
            onDisabled()
        @unknown default:
            fatalError("Unhandled authorizationStatus")
        }
    }

    func didTapMenu() {
        coordinatorDelegate?.startMenuFlow()
    }

    func didTapImage() {
        //For debugging stuff
    }
}
