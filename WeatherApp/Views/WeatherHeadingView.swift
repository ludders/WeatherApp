//
//  WeatherHeadingView.swift
//  WeatherApp
//
//  Created by dludlow7 on 25/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

class WeatherHeadingView: UIView {

    var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise.circle"), for: .normal)
        button.imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .footnote)
        button.tintColor = Theme.Colours.primaryGrey
        return button
    }()
    var refreshLabel: UILabel = {
        let label = UILabel()
        label.text = "3 minutes ago"
        label.font = Theme.Fonts.BBC.footnote
        label.textColor = Theme.Colours.primaryGrey
        return label
    }()
    var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "London"
        label.font = Theme.Fonts.BBC.largeTitle
        label.textColor = Theme.Colours.primaryWhite
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.7
        return label
    }()
    var addLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.square"), for: .normal)
        button.imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.tintColor = Theme.Colours.primaryWhite
        return button
    }()
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Next Hour"
        label.font = Theme.Fonts.BBC.largeSubTitle
        label.textColor = Theme.Colours.primaryWhite
        return label
    }()
//    var sunriseStackView: UIStackView {
//        return nil
//    }

    func setupView() {
        addSubview(refreshButton)
        addSubview(refreshLabel)
        addSubview(locationLabel)
        addSubview(addLocationButton)
        addSubview(subtitleLabel)
//        addSubview(sunriseStackView)
        setupConstraints()
    }

    func setupConstraints() {

        layoutMargins = UIEdgeInsets(top: 64, left: 20, bottom: 20, right: 20)

        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(48+8)
            make.leading.equalTo(layoutMarginsGuide)
        }

        refreshLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(48+8)
            make.leading.equalTo(refreshButton.snp.trailing).offset(8)
            make.centerY.equalTo(refreshButton)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(refreshButton.snp.bottom).offset(16)
            make.leading.equalTo(layoutMarginsGuide)
        }

        addLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(locationLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(layoutMarginsGuide)
            make.centerY.equalTo(locationLabel)
        }
        addLocationButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide)
            make.top.equalTo(locationLabel.snp.bottom).offset(16)
        }

    }
}
