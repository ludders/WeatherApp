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
    var currentDayCollectionView: UICollectionView!
    var dayScrollView: UIScrollView!

    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(headingView)
        headingView.setupView()
        setupConstraints()
    }

    func setupConstraints() {
        headingView.snp.makeConstraints { make in
            make.top.leading.width.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).dividedBy(3)
        }
    }
}
