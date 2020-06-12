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
            showWeather()
        } else {
            UserDefaults.standard.set(true, forKey: "hasSeenIntro")
            showIntro()
        }
    }

    private func showWeather() {
        //TODO: Set up data source / view controllers for this.
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        let viewModel = WeatherViewModel()
        let layout = UICollectionViewFlowLayout()
        let hourlyViewController = ForecastCollectionViewController(viewModel: viewModel, layout: layout)
        let vc1 = WeatherViewController(weatherViewModel: viewModel,
                                        hourlyViewController: hourlyViewController)
        pageViewController.setViewControllers([vc1], direction: .forward, animated: true, completion: nil)
        let weatherContainerViewController = WeatherContainerViewController(pageViewController: pageViewController)
        navigationController.pushViewController(weatherContainerViewController, animated: true)
    }

    private func showIntro() {
        let introViewController = IntroViewController()
        introViewController.delegate = self
        navigationController.pushViewController(introViewController, animated: true)
    }
}

extension MainCoordinator: IntroViewControllerDelegate {
    func animationDidFInish() {
        showWeather()
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
