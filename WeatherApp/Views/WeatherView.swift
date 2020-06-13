//
//  WeatherView.swift
//  WeatherApp
//
//  Created by dludlow7 on 25/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class WeatherView: UIView {

    var headingView = WeatherHeadingView()
    var forecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    var daysView = DaysView()

    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(headingView)
        addSubview(forecastCollectionView)
        headingView.setupView()
        setupConstraints()
    }

    private func setupConstraints() {
        headingView.snp.makeConstraints { make in
            make.top.leading.width.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).dividedBy(3)
        }
        forecastCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headingView.snp.bottom)
            make.leading.width.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }

    func configure(with locationForecast: LocationForecast) {
        self.headingView.configure(with: locationForecast)
        DispatchQueue.main.async {
            self.forecastCollectionView.reloadData()
        }
    }
}
