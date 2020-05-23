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

class WeatherViewController: UIViewController {

    var containerView: UIView!
    var headerView: HeaderView!

    override func loadView() {
        containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = Theme.Colours.black
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView = HeaderView()
        headerView.tintColor = Theme.Colours.primaryWhite
        containerView.addSubview(headerView)
        headerView.configure()

//        let service = WeatherService()
//        let req = WeatherRequest(latitude: "51.6365",
//                                 longitude: "0.6171",
//                                 units: "metric")
//
//        service.getWeatherResponse(for: req, onCompletion: { response in
//            print(response)
//        }, onFailure: nil)
    }
}
