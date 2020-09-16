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
}

extension MainCoordinator: IntroViewControllerDelegate {
    func showHomeScreen() {
        let locationManager = CLLocationManager()
        let deviceLocationProvider = DeviceLocationProvider(locationManager: locationManager)
        let homeViewModel = HomeViewModel(deviceLocationProvider: deviceLocationProvider)
        homeViewModel.coordinatorDelegate = self
        
        let locations: [Location] = [
            Location(name: "South Woodham Ferrers", coordinates: CLLocationCoordinate2D(latitude: 51.6465, longitude: 0.6147)),
            Location(name: "Stratford", coordinates: CLLocationCoordinate2D(latitude: 51.5472, longitude: -0.0081)),
            Location(name: "Manchester", coordinates: CLLocationCoordinate2D(latitude: 53.4808, longitude: 2.2426))
        ]
        Defaults.set(locations, forKey: .savedLocations)

        guard let savedLocations = Defaults.get([Location].self, forKey: .savedLocations) else { return } //TODO: No Saved Locations logic
        savedLocations.forEach { location in
            print(location)
        }
        let pageViewControllerDataSource = LocationPageViewControllerDataSource(locations: savedLocations)
        let homeViewController = HomeViewController(viewModel: homeViewModel,
                                                    locationPageViewControllerDataSource: pageViewControllerDataSource)
        navigationController.pushViewController(homeViewController, animated: true)
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

    func showWeather(for location: Location) {
        //TODO: Reimplement this for multiple forecast display
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
