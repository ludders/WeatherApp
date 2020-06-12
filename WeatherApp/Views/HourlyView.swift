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

class HourlyView: UIView {

    let collectionView: UICollectionView

    public init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: CGRect.zero)
    }

    func setupView() {
        setupCollectionView()
        addSubview(collectionView)
        setupConstraints()
    }

    private func setupCollectionView() {
        collectionView.register(CurrentWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "currentWeather")
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
