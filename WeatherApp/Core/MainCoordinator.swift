//
//  MainCoordinator.swift
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

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?
    var navigationController: UINavigationController
    var navigationControllerDelegate: UINavigationControllerDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationControllerDelegate = NavigationTransitionDelegate()
        navigationController.delegate = navigationControllerDelegate
    }

    func start() {
        if let hasSeenIntro = Defaults.get(Bool.self, forKey: .hasSeenIntro),
            hasSeenIntro {
//            showDefaultWeatherLocation()
            showHomeScreen()
        } else {
            Defaults.set(true, forKey: .hasSeenIntro)
            startIntroFlow()
        }
    }

    private func startIntroFlow() {
        let introViewController = IntroViewController()
        introViewController.coordinatorDelegate = self
        navigationController.pushViewController(introViewController, animated: true)
    }

    private func showHomeScreen() {
        let locationManager = CLLocationManager()
        let deviceLocationProvider = DeviceLocationProvider(locationManager: locationManager)
        let homeViewModel = HomeViewModel(deviceLocationProvider: deviceLocationProvider)

        let locations: [Location] = [
            Location(name: "Test1", coordinates: CLLocationCoordinate2D(latitude: 9.89600, longitude: 131.22371)),
            Location(name: "Test2", coordinates: CLLocationCoordinate2D(latitude: -9.38387, longitude: -97.18881)),
            Location(name: "Test3", coordinates: CLLocationCoordinate2D(latitude: -52.41806, longitude: 88.99633))
        ]
        Defaults.set(locations, forKey: .savedLocations)

        guard let savedLocations = Defaults.get([Location].self, forKey: .savedLocations) else { return } //TODO: No Saved Locations logic
        savedLocations.forEach { location in
            print(location)
        }
        let pageViewControllerDataSource = LocationPageViewControllerDataSource(locations: savedLocations)
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        guard let initialViewController = pageViewControllerDataSource.initialPageViewController() else { return } //TODO: No Saved Locations logic
        pageViewController.setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = pageViewControllerDataSource

        let homeViewController = HomeViewController(viewModel: homeViewModel, pageViewController: pageViewController)
        navigationController.pushViewController(homeViewController, animated: true)
    }
}

extension MainCoordinator: IntroViewControllerDelegate {
    func showDefaultWeatherLocation() {
        if let locations = Defaults.get([Location].self, forKey: .savedLocations),
            !locations.isEmpty {
            showWeather(for: locations.first(where: { $0.isDefault }) ?? locations.first!)
        } else {
            showWeather(for: Location(name: "Null Island",
                                      latitude: 0,
                                      longitude: 0,
                                      isDefault: false))
        }
    }
}

extension MainCoordinator: SearchViewControllerDelegate {
    func didTapClose() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

extension MainCoordinator: HomeViewModelDelegate {
    func startSearchFlow() {
        let suggestionsAPI = SuggestionsAPI()
        let suggestionsService = SuggestionsService(suggestionsAPI: suggestionsAPI)
        let viewModel = SearchViewModel(suggestionsService: suggestionsService)
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchViewController.coordinatorDelegate = self
        navigationController.present(searchViewController, animated: true)
    }

    //This will go when multi pages is enabled?
    func showWeather(for location: Location) {
//        let model = LocationModel(location: location)
//        let locationViewModel = LocationViewModel(model: model)
//        let forecastCollectionViewDataSource = ForecastCollectionViewDataSource(viewModel: locationViewModel)
//        let dayCollectionViewDataSource = DayCollectionViewDataSource(viewModel: locationViewModel)
//        let locationViewController = LocationViewController(viewModel: locationViewModel,
//                                        forecastCollectionViewDataSource: forecastCollectionViewDataSource,
//                                        dayCollectionViewDataSource: dayCollectionViewDataSource)
//
//        let locationManager = CLLocationManager()
//        let deviceLocationProvider = DeviceLocationProvider(locationManager: locationManager)
//        let homeViewModel = HomeViewModel(deviceLocationProvider: deviceLocationProvider, locationViewModels: [locationViewModel])
//        homeViewModel.coordinatorDelegate = self
//        let homeViewController = HomeViewController(viewModel: homeViewModel, locationViewController: locationViewController)
//        navigationController.pushViewController(homeViewController, animated: true)
    }
}

class NavigationTransitionDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimationController()
    }
}

class FadeInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: .to)
            else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0.0

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        toVC.view.alpha = 1.0
        }) { hasFinished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
