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
    let dayCollectionView: UICollectionView
    let forecastflowLayout: UICollectionViewFlowLayout
    let dayFlowLayout: UICollectionViewFlowLayout

    init(forecastFlowLayout: UICollectionViewFlowLayout,
         dayFlowLayout: UICollectionViewFlowLayout) {
        self.forecastflowLayout = forecastFlowLayout
        self.forecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: forecastFlowLayout)
        self.dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: dayFlowLayout)
        self.dayFlowLayout = dayFlowLayout
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        fatalError("No storyboards!")
    }

    func setupView() {
        addSubview(headingView)
        addSubview(forecastCollectionView)
        addSubview(dayCollectionView)
        headingView.setupView()
        setupForecastCollectionView()
        setupDayCollectionView()
        setupConstraints()
    }

    //MARK: Forecast Collection View & Layout Setup

    private func setupForecastCollectionView() {
        forecastCollectionView.register(DailyForecastCollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        forecastCollectionView.register(HourlyForecastCollectionViewCell.self, forCellWithReuseIdentifier: "hourCell")

        forecastflowLayout.scrollDirection = .horizontal
        forecastCollectionView.isPagingEnabled = true
        forecastCollectionView.backgroundColor = Theme.Colours.black
    }

    //MARK: Day Collection View & Layout Setup

    private func setupDayCollectionView() {
        dayCollectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "dayCollectionViewCell")
        dayFlowLayout.scrollDirection = .horizontal
        dayCollectionView.backgroundColor = Theme.Colours.black
    }

    //MARK: Constraints

    private func setupConstraints() {
        headingView.snp.makeConstraints { make in
            make.top.leading.width.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).dividedBy(3)
        }
        forecastCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headingView.snp.bottom).offset(5)
            make.leading.width.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(dayCollectionView.snp.top).offset(-10)
        }
        dayCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    func configure(with locationModel: LocationModel) {
        self.headingView.configure(with: locationModel)
        DispatchQueue.main.async {
            self.forecastCollectionView.reloadData()
            self.dayCollectionView.reloadData()
        }
    }
}


