//
//  HomeFactory.swift
//  WeatherApp
//
//  Created by dludlow7 on 13/11/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

struct HomeFactory {
    let defaults: Defaults

    init(defaults: Defaults) {
        self.defaults = defaults
    }

    func getHomeViewController(homeViewModelDelegate: HomeViewModelDelegate) -> HomeViewController {
        let locationManager = CLLocationManager()
        let deviceLocationProvider = DeviceLocationProvider(locationManager: locationManager)

        let homeViewModel = HomeViewModel(deviceLocationProvider: deviceLocationProvider)
        homeViewModel.coordinatorDelegate = homeViewModelDelegate

        let locationRepository = LocationRepository(defaults: defaults)
        let weatherService = WeatherService(locationRepository: locationRepository)
        let savedLocations = getSavedLocations()
        weatherService.updateForecasts(for: savedLocations)

        let pageViewControllerDataSource = LocationPageViewControllerDataSource(locations: savedLocations,
                                                                                weatherService: weatherService,
                                                                                locationRepository: locationRepository)
        return HomeViewController(viewModel: homeViewModel,
                                  locationPageViewControllerDataSource: pageViewControllerDataSource)
    }

    private func getSavedLocations() -> [Location] {
        let defaultLocations: [Location] = [
            Location(name: "South Woodham Ferrers", coordinates: CLLocationCoordinate2D(latitude: 51.6465, longitude: 0.6147), saved: true),
            Location(name: "Stratford", coordinates: CLLocationCoordinate2D(latitude: 51.5472, longitude: -0.0081), saved: true),
            Location(name: "Manchester", coordinates: CLLocationCoordinate2D(latitude: 53.4808, longitude: 2.2426), saved: true)
        ]

        if defaults.hasKey(.savedLocations) == false {
            defaults.set(defaultLocations, forKey: .savedLocations)
        }

        let savedLocations: [Location] = defaults.get(.savedLocations)!
        savedLocations.forEach { print("\($0.name) lat: \($0.latitude) long: \($0.longitude)") }
        return savedLocations
    }
}
