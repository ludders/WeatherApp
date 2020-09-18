//
//  LocationView.swift
//  WeatherApp
//
//  Created by dludlow7 on 25/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

final class LocationView: UIView {
    let headingView = LocationHeaderView()
    let forecastCollectionView: UICollectionView
    let dayCollectionView: UICollectionView
    let forecastflowLayout: UICollectionViewFlowLayout
    let dayFlowLayout: UICollectionViewFlowLayout

    private var shouldHideForecast = false {
        didSet {
            hideForecast(hide: shouldHideForecast)
        }
    }

    init(forecastFlowLayout: UICollectionViewFlowLayout,
         dayFlowLayout: UICollectionViewFlowLayout) {
        self.forecastflowLayout = forecastFlowLayout
        self.forecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: forecastFlowLayout)
        self.dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: dayFlowLayout)
        self.dayFlowLayout = dayFlowLayout
        super.init(frame: CGRect.zero)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        addSubview(headingView)
        addSubview(forecastCollectionView)
        addSubview(dayCollectionView)
        setupForecastCollectionView()
        setupDayCollectionView()
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

    func setupConstraints() {
        headingView.snp.makeConstraints { make in
            make.top.leading.width.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(150)
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

    func configure(for state: LocationViewState) {
        switch state {
            case .loading:
                shouldHideForecast = true
            case .loaded(let model):
                self.headingView.configure(with: model)
                DispatchQueue.main.async {
                    self.forecastCollectionView.reloadData()
                    self.dayCollectionView.reloadData()
                }
                shouldHideForecast = false
            case .error:
                shouldHideForecast = true
        }
    }

    private func hideForecast(hide: Bool) {
        DispatchQueue.main.async {
            self.forecastCollectionView.isHidden = self.shouldHideForecast
            self.dayCollectionView.isHidden = self.shouldHideForecast
            self.headingView.hideForecast(hide: hide)
        }
    }
}


