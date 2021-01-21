//
//  HomeContainerViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 11/01/2021.
//  Copyright © 2021 David Ludlow. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class SlidingMenuViewController: UIViewController {

    private var menuView: UIView!
    private var contentContainerView: UIView = UIView()
    private var contentView: UIView!
    private lazy var menuButton: Button = {
        let button = Button(type: .system)
        button.tintColor = Theme.Colours.white
        button.setTitle(NSLocalizedString("Menu", comment: "Menu"), for: .normal)
        button.onTouchUpInside {
            self.didTapMenuButton()
        }
        return button
    }()

    private var menuViewController: UIViewController
    private var contentViewController: UIViewController

    init(menuViewController: UIViewController,
         contentViewController: UIViewController) {
        self.menuViewController = menuViewController
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Controller Setup & Lifecycle

    override func viewDidLoad() {
        setupMenuView()
        setupContentView()
        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view.layoutMarginsGuide)
        }
    }

    private func setupMenuView() {
        addChild(menuViewController)
        menuView = menuViewController.view
        view.addSubview(menuView)
        menuViewController.view.frame = view.frame
        menuViewController.didMove(toParent: self)
    }

    private func setupContentView() {
        addChild(contentViewController)
        contentView = contentViewController.view
        contentContainerView.addSubview(contentViewController.view)
        contentContainerView.frame = view.frame
        view.addSubview(contentContainerView)
        contentViewController.view.frame = contentContainerView.frame
        contentViewController.didMove(toParent: self)
    }

    // MARK: Content View animation & interaction

    private let halfScreenWidth = UIScreen.main.bounds.width/2

    private func slideLeftAnimation() {
        contentContainerView.transform = CGAffineTransform.identity
        menuButton.transform = CGAffineTransform.identity
    }

    private lazy var panLeftAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: slideLeftAnimation)

    private func didTapMenuButton() {
        revealMenuView()
        contentContainerView.addGestureRecognizer({
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))
            recognizer.delegate = self
            return recognizer
        }())
        contentContainerView.addGestureRecognizer({
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanContentView))
            recognizer.delegate = self
            return recognizer
        }())
    }

    private func revealMenuView() {
        menuIsOpen = true
        UIView.animate(withDuration: 0.2) { [self] in
            self.contentContainerView.transform = CGAffineTransform(translationX: halfScreenWidth, y: 0)
            self.menuButton.transform = CGAffineTransform(translationX: halfScreenWidth, y: 0)
        }
    }

    private var menuIsOpen: Bool = false {
        didSet {
            if menuIsOpen {
                contentView.isUserInteractionEnabled = false
                menuButton.isUserInteractionEnabled = false
            } else {
                contentView.isUserInteractionEnabled = true
                menuButton.isUserInteractionEnabled = true
            }
        }
    }

    @objc
    private func didTapContentView(_ sender: UIGestureRecognizer) {
        guard let recognizer = sender as? UITapGestureRecognizer,
              recognizer.state == .ended else { return }
        panLeftAnimator.addAnimations(slideLeftAnimation)
        panLeftAnimator.startAnimation()
        panLeftAnimator.addCompletion(panEnded(_:))
    }

    @objc
    private func didPanContentView(_ sender: UIGestureRecognizer) {
        guard let recognizer = sender as? UIPanGestureRecognizer else { return }
        let xPosition = recognizer.translation(in: view).x
        let isPanningLeft = xPosition < 0

        switch recognizer.state {
        case .began:
            if isPanningLeft {
                beginPanAnimation()
            }
        case .changed:
            let xPosition = recognizer.translation(in: view).x
            let fractionCompleted = 1-((halfScreenWidth + xPosition) / halfScreenWidth)
            panLeftAnimator.fractionComplete = fractionCompleted
        case .ended:
            endPanAnimation()
        default:
            ()
        }
    }

    private func beginPanAnimation() {
        panLeftAnimator.addAnimations(slideLeftAnimation)
        panLeftAnimator.startAnimation()
        panLeftAnimator.pauseAnimation()
    }

    private func endPanAnimation() {
        if panLeftAnimator.fractionComplete < 0.4 {
            panLeftAnimator.isReversed = true
        }
        panLeftAnimator.addCompletion(panEnded(_:))
        panLeftAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }

    private func panEnded(_ position: UIViewAnimatingPosition) {
        if position == .end {
            menuIsOpen = false
            contentContainerView.gestureRecognizers?.forEach { recognizer in
                contentContainerView.removeGestureRecognizer(recognizer)
            }
        } else {
            menuIsOpen = true
        }
    }
}

extension SlidingMenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == contentContainerView && otherGestureRecognizer.view == contentContainerView {
            return true
        } else {
            return false
        }
    }
}
