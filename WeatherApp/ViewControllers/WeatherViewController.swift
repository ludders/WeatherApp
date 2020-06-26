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

    let forecastCollectionViewController: UICollectionViewController
    let forecastCollectionViewDataSource: ForecastCollectionViewDataSource
    let forecastFlowLayout = UICollectionViewFlowLayout()
    let forecastCollectionViewDelegateFlowLayout = ForecastCollectionViewDelegateFlowLayout()

    let dayCollectionViewController: UICollectionViewController
    let dayCollectionViewDataSource: DayCollectionViewDataSource
    let dayFlowLayout = UICollectionViewFlowLayout()
    let dayCollectionViewDelegateFlowLayout = DayCollectionViewDelegateFlowLayout()

    init(weatherViewModel: WeatherViewModel,
         forecastCollectionViewDataSource: ForecastCollectionViewDataSource,
        dayCollectionViewDataSource: DayCollectionViewDataSource) {
        self.weatherViewModel = weatherViewModel
        self.forecastCollectionViewController = UICollectionViewController(collectionViewLayout: forecastFlowLayout)
        self.forecastCollectionViewDataSource = forecastCollectionViewDataSource
        self.dayCollectionViewController = UICollectionViewController(collectionViewLayout: dayFlowLayout)
        self.dayCollectionViewDataSource = dayCollectionViewDataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        weatherView = WeatherView(forecastFlowLayout: forecastFlowLayout, dayFlowLayout: dayFlowLayout)
        weatherView.backgroundColor = Theme.Colours.black
        view = weatherView
    }

    override func viewDidLoad() {
        addChildViewControllers()
        weatherView.setupView()
        configureForecastCollectionView()
        configureDayCollectionView()
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

        addChild(dayCollectionViewController)
        dayCollectionViewController.collectionView = weatherView.dayCollectionView
        dayCollectionViewController.didMove(toParent: self)
    }

    private func configureForecastCollectionView() {
        weatherView.forecastCollectionView.delegate = forecastCollectionViewDelegateFlowLayout
        weatherView.forecastCollectionView.dataSource = forecastCollectionViewDataSource
    }

    private func configureDayCollectionView() {
        weatherView.dayCollectionView.delegate = dayCollectionViewDelegateFlowLayout
        weatherView.dayCollectionView.dataSource = dayCollectionViewDataSource
    }

    @objc func didTapRefresh() {
        weatherViewModel.updateForecast()
    }
}
