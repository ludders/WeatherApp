//
//  SlideRightMenuAnimationController.swift
//  WeatherApp
//
//  Created by dludlow7 on 10/12/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class SlideRightMenuAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private var halfScreenWidth: CGFloat {
        return UIScreen.main.bounds.width/2
    }

    private var menuViewSize: CGSize {
        return CGSize(width: halfScreenWidth, height: UIScreen.main.bounds.height)
    }

    private var context: UIViewControllerContextTransitioning!

    private lazy var containerView: UIView = {
        return context.containerView
    }()

    private lazy var currentViewController: UIViewController = {
        return context.viewController(forKey: .from)!
    }()

    private lazy var menuViewController: UIViewController = {
        let vc = context.viewController(forKey: .to)!
        vc.view.frame = CGRect(origin: .zero, size: menuViewSize)
        return vc
    }()

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.2
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        containerView.addSubview(menuViewController.view)
        containerView.addSubview(currentViewController.view)

        UIView.animate(withDuration: transitionDuration(using: context)) { [self] in
            self.currentViewController.view.transform = CGAffineTransform(translationX: halfScreenWidth, y: 0)
        } completion: { hasFinished in
            self.context.completeTransition(!self.context.transitionWasCancelled)
        }
    }
}
