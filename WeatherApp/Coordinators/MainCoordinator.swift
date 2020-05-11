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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
//        if UserDefaults.standard.bool(forKey: "hasSeenIntro") {
        if false {
            showWeather()
        } else {
            UserDefaults.standard.set(true, forKey: "hasSeenIntro")
            showIntro()
        }
    }

    private func showWeather() {
        let weatherViewController = WeatherViewController()
        navigationController.pushViewController(weatherViewController, animated: true)
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

//TODO: Amend this so that each time a VC is pushed onto the NC, the animation type can be specified.

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
