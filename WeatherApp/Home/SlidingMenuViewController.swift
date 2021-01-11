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
        view.addSubview(menuViewController.view)
        menuViewController.view.frame = view.frame
        menuViewController.didMove(toParent: self)
    }

    private func setupContentView() {
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.view.frame = view.frame
        contentViewController.didMove(toParent: self)
    }

    private func didTapMenuButton() {
        //TODO: Menu animation
        //Fade menu button
        //Slide contentView to the right
        //Disable contentView interaction
    }
}
