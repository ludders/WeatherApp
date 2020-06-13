//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 23/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    var weatherView: WeatherView!
    var weatherViewModel: WeatherViewModel
    let forecastCollectionViewController: UICollectionViewController = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    let forecastCollectionViewDataSource: ForecastCollectionViewDataSource

    init(weatherViewModel: WeatherViewModel,
         forecastCollectionViewDataSource: ForecastCollectionViewDataSource) {
        self.weatherViewModel = weatherViewModel
        self.forecastCollectionViewDataSource = forecastCollectionViewDataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        weatherView = WeatherView()
        setupForecastCollectionView()
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
        forecastCollectionViewController.collectionView = weatherView.forecastCollectionView
        forecastCollectionViewController.didMove(toParent: self)
    }

    private func setupForecastCollectionView() {
        weatherView.forecastCollectionView.register(TestCell.self, forCellWithReuseIdentifier: "testCell")
        weatherView.forecastCollectionView.register(CurrentWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "currentCell")
        weatherView.forecastCollectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        weatherView.forecastCollectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "hourCell")
        weatherView.forecastCollectionView.dataSource = forecastCollectionViewDataSource
    }

    @objc func didTapRefresh() {
        weatherViewModel.updateForecast()
    }
}
