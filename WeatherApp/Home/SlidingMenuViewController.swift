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

    private var menuViewController: UIViewController
    private var contentViewController: UIViewController

    init(menuViewController: UIViewController, contentViewController: UIViewController) {
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
}

//- (void) displayContentController: (UIViewController*) content {
//   [self addChildViewController:content];
//   content.view.frame = [self frameForContentController];
//   [self.view addSubview:self.currentClientView];
//   [content didMoveToParentViewController:self];
//}
