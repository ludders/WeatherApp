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
        fatalError("init(coder:) has not been implemented")
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
            make.top.equalTo(headingView.snp.bottom)
            make.leading.width.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(dayCollectionView.snp.top)
        }
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(forecastCollectionView.snp.bottom)
            make.height.equalTo(100)
            make.width.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    func configure(with locationForecast: LocationForecast) {
        self.headingView.configure(with: locationForecast)
        DispatchQueue.main.async {
            self.forecastCollectionView.reloadData()
            self.dayCollectionView.reloadData()
        }
    }
}

// MARK: Forecast Collection View Delegate Flow Layout
class ForecastCollectionViewDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            //Day/Current cell
            return collectionView.visibleSize
        } else {
            let width = collectionView.visibleSize.width/5
            let height = collectionView.visibleSize.height
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: Day Collection View Delegate Flow Layout
class DayCollectionViewDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
