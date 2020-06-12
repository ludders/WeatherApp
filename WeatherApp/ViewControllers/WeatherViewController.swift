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
    let forecastCollectionViewController: ForecastCollectionViewController

    init(weatherViewModel: WeatherViewModel,
         hourlyViewController: ForecastCollectionViewController) {
        self.weatherViewModel = weatherViewModel
        self.forecastCollectionViewController = hourlyViewController
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
        addChildViewControllers()
        weatherView.setupView()
        weatherViewModel.updateForecast()
        weatherViewModel.locationForecast.bind { locationForecast in
            self.weatherView.configure(with: locationForecast)
        }
        weatherView.headingView.refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
    }

    private func addChildViewControllers() {
        addChild(forecastCollectionViewController)
        forecastCollectionViewController.collectionView = weatherView.hourlyView.collectionView
        forecastCollectionViewController.collectionView.backgroundColor = .systemPink
        forecastCollectionViewController.didMove(toParent: self)
    }

    @objc func didTapRefresh() {
        weatherViewModel.updateForecast()
    }
}
