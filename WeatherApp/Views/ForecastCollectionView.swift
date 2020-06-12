//
//  HourlyView.swift
//  WeatherApp
//
//  Created by dludlow7 on 07/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class ForecastCollectionView: UICollectionView {

    public init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    func setup() {
        self.register(CurrentWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "currentCell")
        self.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        self.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "hourCell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
