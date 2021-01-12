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

    let halfScreenWidth = UIScreen.main.bounds.width/2
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanContentView))
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))

    //TODO: Drag/Tap to close animation is stuffed because there are multiple gesture recognizers on the same view
    //...sort out!

    private func didTapMenuButton() {
        contentView.isUserInteractionEnabled = false
        menuButton.isUserInteractionEnabled = false
        revealMenuView()
        contentContainerView.addGestureRecognizer(panGestureRecognizer)
        contentContainerView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func revealMenuView() {
        UIView.animate(withDuration: 0.2) { [self] in
            self.contentContainerView.transform = CGAffineTransform(translationX: halfScreenWidth, y: 0)
            self.menuButton.transform = CGAffineTransform(translationX: halfScreenWidth, y: 0)

        }
    }

    var panAnimator: UIViewPropertyAnimator!

    @objc
    private func didPanContentView(_ sender: UIGestureRecognizer) {
        guard let recognizer = sender as? UIPanGestureRecognizer else { return }
        let xPosition = recognizer.translation(in: view).x
        let isPanningLeft = xPosition < 0

        switch recognizer.state {
        case .began:
            if isPanningLeft {
                panAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { [self] in
                    contentContainerView.transform = CGAffineTransform.identity
                    menuButton.transform = CGAffineTransform.identity
                })
                panAnimator.startAnimation()
                panAnimator.pauseAnimation()
            }
        case .changed:
            let xPosition = recognizer.translation(in: view).x
            panAnimator?.fractionComplete = 1-((halfScreenWidth + xPosition) / halfScreenWidth)
        case .ended:
            if panAnimator.fractionComplete < 0.4 {
                panAnimator.isReversed = true
            }
            panAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            panAnimator.addCompletion(menuWasHidden(_:))
        default:
            ()
        }
    }

    private func menuWasHidden(_ position: UIViewAnimatingPosition) {
        contentContainerView.removeGestureRecognizer(panGestureRecognizer)
        contentContainerView.removeGestureRecognizer(tapGestureRecognizer)
        contentView.isUserInteractionEnabled = true
    }

    @objc
    private func didTapContentView(_ sender: UIGestureRecognizer) {
        guard let recognizer = sender as? UITapGestureRecognizer,
              recognizer.state == .ended else { return }
        panAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { [self] in
            contentContainerView.transform = CGAffineTransform.identity
            menuButton.transform = CGAffineTransform.identity
        })
        panAnimator.startAnimation()
        panAnimator.addCompletion(menuWasHidden(_:))
    }
}
