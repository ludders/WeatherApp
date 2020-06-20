//
//  WeatherView.swift
//  WeatherApp
//
//  Created by dludlow7 on 25/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

final class WeatherView: UIView {
    let headingView = WeatherHeadingView()
    let forecastCollectionView: UICollectionView
    let flowLayout: UICollectionViewFlowLayout
//    var daysView = DaysView()

    init(flowLayout: UICollectionViewFlowLayout) {
        self.flowLayout = flowLayout
        self.forecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(headingView)
        addSubview(forecastCollectionView)
        headingView.setupView()
        setupForecastCollectionView()
        setupConstraints()
    }

    //MARK: Forecast Collection View & Layout Setup

    private func setupForecastCollectionView() {
        forecastCollectionView.register(TestCell.self, forCellWithReuseIdentifier: "testCell")
        forecastCollectionView.register(CurrentWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "currentCell")
        forecastCollectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        forecastCollectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "hourCell")

        flowLayout.scrollDirection = .horizontal
        forecastCollectionView.isPagingEnabled = true
    }

    private func setupConstraints() {
        headingView.snp.makeConstraints { make in
            make.top.leading.width.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).dividedBy(3)
        }
        forecastCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headingView.snp.bottom)
            make.leading.width.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.45)
        }
    }

    func configure(with locationForecast: LocationForecast) {
        self.headingView.configure(with: locationForecast)
        DispatchQueue.main.async {
            self.forecastCollectionView.reloadData()
        }
    }
}
