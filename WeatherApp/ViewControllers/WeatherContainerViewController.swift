//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 01/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

//Will manage header view & act as parent for weather page view controller
class WeatherContainerViewController: UIViewController {

    var containerView: UIView!
    var headerView: HeaderView!
    var pageViewController: UIPageViewController

    init(pageViewController: UIPageViewController) {
        self.pageViewController = pageViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        containerView = UIView(frame: UIScreen.main.bounds)
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupHeaderView()
//        TEST_weatherCall()
    }

    private func setupHeaderView() {
        headerView = HeaderView()
        headerView.tintColor = Theme.Colours.primaryWhite
        containerView.addSubview(headerView)
        headerView.setupView()
    }

    private func setupPageViewController() {
        containerView.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }

    private func TEST_weatherCall() {
        let service = WeatherService()
        let req = WeatherRequest(latitude: "51.6365",
                                 longitude: "0.6171",
                                 units: "metric")

        service.getWeatherResponse(for: req, onCompletion: { response in
            print(response)
        }, onFailure: nil)
    }
}
