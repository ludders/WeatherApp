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

        let savedLocations = getSavedLocations()
        let locationStore = LocationStore(locations: savedLocations, defaults: defaults)
        let weatherService = WeatherService(locationStore: locationStore)
        weatherService.updateForecasts(for: savedLocations)

        let pageViewControllerDataSource = LocationPageViewControllerDataSource(weatherService: weatherService,
                                                                                locationStore: locationStore)
        return HomeViewController(viewModel: homeViewModel,
                                  locationStore: locationStore,
                                  locationPageViewControllerDataSource: pageViewControllerDataSource)
    }

    private func getSavedLocations() -> [Location] {
        let defaultLocations: [Location] = []

        if defaults.hasKey(.savedLocations) == false {
            defaults.set(defaultLocations, forKey: .savedLocations)
        }

        let savedLocations: [Location] = defaults.get(.savedLocations)!
        return savedLocations
    }
}
