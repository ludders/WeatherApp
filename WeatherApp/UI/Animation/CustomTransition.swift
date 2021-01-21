//
//  CustomTransition.swift
//  WeatherApp
//
//  Created by dludlow7 on 13/11/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol CustomTransitionProtocol {
    var animationController: UIViewControllerAnimatedTransitioning { get }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
}

class CustomTransition: CustomTransitionProtocol {
    var animationController: UIViewControllerAnimatedTransitioning

    init(using animationController: UIViewControllerAnimatedTransitioning) {
        self.animationController = animationController
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
}

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    var customTransitionProtocol: CustomTransitionProtocol

    init(customTransitionProtocol: CustomTransitionProtocol) {
        self.customTransitionProtocol = customTransitionProtocol
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customTransitionProtocol.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
}
