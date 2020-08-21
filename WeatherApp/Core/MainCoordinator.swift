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
        if UserDefaults.standard.bool(forKey: "hasSeenIntro") {
            startWeatherFlow()
        } else {
            UserDefaults.standard.set(true, forKey: "hasSeenIntro")
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
    func startWeatherFlow() {
        if let location = Defaults.get(Location.self, forKey: .defaultLocation) {
            startWeatherFlow(for: location)
        } else {
            startWeatherFlow(for: Location(name: "Null Island",
                                           latitude: 0,
                                           longitude: 0))
        }
    }
}

extension MainCoordinator: SearchViewControllerDelegate {
    func startWeatherFlow(for location: Location, setAsDefault: Bool = true) {
        if setAsDefault {
            Defaults.set(location, forKey: .defaultLocation)
        }
        startWeatherFlow(for: location)
    }

    private func startWeatherFlow(for location: Location) {
        let model = LocationModel(location: location)
        let viewModel = WeatherViewModel(model: model)
        let forecastCollectionViewDataSource = ForecastCollectionViewDataSource(viewModel: viewModel)
        let dayCollectionViewDataSource = DayCollectionViewDataSource(viewModel: viewModel)
        let vc1 = WeatherViewController(weatherViewModel: viewModel,
                                        forecastCollectionViewDataSource: forecastCollectionViewDataSource,
                                        dayCollectionViewDataSource: dayCollectionViewDataSource)

        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        pageViewController.setViewControllers([vc1], direction: .forward, animated: true, completion: nil)
        let locationManager = CLLocationManager()
        let currentLocationProvider = CurrentLocationProvider(locationManager: locationManager)
        let homeViewController = HomeViewController(pageViewController: pageViewController,
                                                                            currentLocationProvider: currentLocationProvider)
        homeViewController.coordinatorDelegate = self
        navigationController.pushViewController(homeViewController, animated: true)
    }

    func didTapClose() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

extension MainCoordinator: HomeViewControllerDelegate {
    func startSearchFlow() {
        let suggestionsAPI = SuggestionsAPI()
        let suggestionsService = SuggestionsService(suggestionsAPI: suggestionsAPI)
        let viewModel = SearchViewModel(suggestionsService: suggestionsService)
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchViewController.coordinatorDelegate = self
        navigationController.present(searchViewController, animated: true) {
            //TODO: Handle search selection
        }
    }

    func startWeatherFlowForCurrentLocation(_ currentLocation: Location) {
        startWeatherFlow(for: currentLocation, setAsDefault: false)
    }
}

class NavigationTransitionDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
