//
//  MainCoordinator.swift
//  WeatherApp
//
//  Created by dludlow7 on 30/04/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

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

    func startWeatherFlow() {
        //TODO: Set up data source / view controllers for this.
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        let viewModel = WeatherViewModel()
        let forecastCollectionViewDataSource = ForecastCollectionViewDataSource(viewModel: viewModel)
        let dayCollectionViewDataSource = DayCollectionViewDataSource(viewModel: viewModel)
        let vc1 = WeatherViewController(weatherViewModel: viewModel,
                                        forecastCollectionViewDataSource: forecastCollectionViewDataSource,
                                        dayCollectionViewDataSource: dayCollectionViewDataSource)
        pageViewController.setViewControllers([vc1], direction: .forward, animated: true, completion: nil)
        let weatherContainerViewController = WeatherContainerViewController(pageViewController: pageViewController)
        weatherContainerViewController.delegate = self
        navigationController.pushViewController(weatherContainerViewController, animated: true)
    }

    private func startIntroFlow() {
        let introViewController = IntroViewController()
        introViewController.delegate = self
        navigationController.pushViewController(introViewController, animated: true)
    }

    private func startSearchFlow() {
        let suggestionsAPI = SuggestionsAPI()
        let suggestionsService = SuggestionsService(suggestionsAPI: suggestionsAPI)
        let viewModel = SearchViewModel(suggestionsService: suggestionsService)
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchViewController.delegate = self
        navigationController.present(searchViewController, animated: true) {
            //TODO: Handle search selection
        }
    }
}

extension MainCoordinator: IntroViewControllerDelegate {
    func introDidFinish() {
        startWeatherFlow()
    }
}

extension MainCoordinator: WeatherContainerViewControllerDelegate {
    func didTapSearch() {
        startSearchFlow()
    }
}

extension MainCoordinator: SearchViewControllerDelegate {
    func didTapClose() {
        navigationController.dismiss(animated: true, completion: nil)
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