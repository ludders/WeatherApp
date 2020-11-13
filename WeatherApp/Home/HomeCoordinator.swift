//
//  HomeCoordinator.swift
//  WeatherApp
//
//  Created by dludlow7 on 30/04/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator]? { get set }
    var navigationController: UINavigationController { get }
}

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?
    var navigationController: UINavigationController
    var navigationControllerDelegate: UINavigationControllerDelegate?
    var defaults: Defaults

    init(navigationController: UINavigationController,
         defaults: Defaults) {
        self.navigationController = navigationController
        self.defaults = defaults
        navigationControllerDelegate = NavigationTransitionDelegate()
        navigationController.delegate = navigationControllerDelegate
    }

    func start() {
        if defaults.get(.hasSeenIntro) == true {
            showHomeScreen()
        } else {
            defaults.set(true, forKey: .hasSeenIntro)
            startIntroFlow()
        }
    }

    private func startIntroFlow() {
        let introViewController = IntroViewController()
        introViewController.coordinatorDelegate = self
        navigationController.pushViewController(introViewController, animated: true)
    }
}

extension HomeCoordinator: IntroViewControllerDelegate {
    func showHomeScreen() {
        let locationManager = CLLocationManager()
        let deviceLocationProvider = DeviceLocationProvider(locationManager: locationManager)
        let homeViewModel = HomeViewModel(deviceLocationProvider: deviceLocationProvider)
        homeViewModel.coordinatorDelegate = self
        let weatherService = WeatherService()
        let savedLocations = getSavedLocations()
        weatherService.updateForecasts(for: savedLocations)
        let pageViewControllerDataSource = LocationPageViewControllerDataSource(locations: savedLocations, weatherService: weatherService)
        let homeViewController = HomeViewController(viewModel: homeViewModel,
                                                    locationPageViewControllerDataSource: pageViewControllerDataSource,
                                                    weatherService: weatherService)
        navigationController.pushViewController(homeViewController, animated: true)
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

extension HomeCoordinator: SearchViewControllerDelegate {
    func didTapClose() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

extension HomeCoordinator: HomeViewModelDelegate {
    func startSearchFlow(delegate: LocationSelectionDelegate?) {
        let suggestionsAPI = SuggestionsAPI()
        let suggestionsService = SuggestionsService(suggestionsAPI: suggestionsAPI)
        let viewModel = SearchViewModel(suggestionsService: suggestionsService)
        let searchViewController = SearchViewController(viewModel: viewModel)
        viewModel.selectionDelegate = delegate
        searchViewController.coordinatorDelegate = self
        navigationController.present(searchViewController, animated: true)
    }
}

