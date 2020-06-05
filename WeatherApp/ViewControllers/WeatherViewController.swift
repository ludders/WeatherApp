//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 23/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {

    var weatherView: WeatherView!
    var weatherViewModel: WeatherViewModel

    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        weatherView = WeatherView()
        weatherView.backgroundColor = Theme.Colours.black
        view = weatherView
    }

    override func viewDidLoad() {
        weatherView.setupView()
        weatherViewModel.updateForecast()
        weatherViewModel.forecast.bind { forecast in
            self.weatherView.configure(with: forecast)
        }
        weatherView.headingView.refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
    }

    @objc func didTapRefresh() {
        weatherViewModel.updateForecast()
    }
}
