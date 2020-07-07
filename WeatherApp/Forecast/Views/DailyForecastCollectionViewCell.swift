//
//  DailyForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by dludlow7 on 12/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class DailyForecastCollectionViewCell: UICollectionViewCell {

    private var symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Theme.Colours.white
        imageView.contentMode = .scaleAspectFit
        imageView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return imageView
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Theme.Fonts.BBC.largeSubTitle
        label.textColor = Theme.Colours.white
        label.text = "Sample Description"
        return label
    }()

    private var maxTempLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = Theme.Fonts.BBC.largeTitle50
        label.textColor = Theme.Colours.white
        label.textAlignment = .center
        return label
    }()

    private var minTempLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.adjustsFontSizeToFitWidth = true
        label.font = Theme.Fonts.BBC.largeTitle50
        label.textColor = Theme.Colours.silver
        label.textAlignment = .center
        return label
    }()

    private var windView: WindIconView = {
        let view = WindIconView()
        view.tintColor = Theme.Colours.white
        view.label.textColor = Theme.Colours.black
        return view
    }()

    func configure(with forecast: DailyForecast) {
        //TODO: All this formatting stuff can probably go in a Cell View Model (Look into this)
        symbolView.image = UIImage(systemName: forecast.symbol ?? "")
        maxTempLabel.text = forecast.maxTemp?.asTemperatureString
        minTempLabel.text = forecast.minTemp?.asTemperatureString
        descriptionLabel.text = forecast.description?.localizedCapitalized
        windView.label.text = String(Int(forecast.windSpeed ?? 0))
        self.windView.degrees = forecast.windDeg ?? 0
        contentView.addSubview(symbolView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(maxTempLabel)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(windView)

        setupConstraints()
    }

    private func setupConstraints() {
        contentView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        symbolView.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView.layoutMarginsGuide)
            make.height.equalTo(200)
            make.bottom.lessThanOrEqualTo(descriptionLabel.snp.top)
            make.trailing.equalTo(maxTempLabel.snp.leading)
        }
        maxTempLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.layoutMarginsGuide)
            make.height.width.equalTo(80)
        }
        minTempLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.layoutMarginsGuide)
            make.top.equalTo(maxTempLabel.snp.bottom)
            make.height.width.equalTo(80)
            make.centerX.equalTo(maxTempLabel)
        }
        windView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.layoutMarginsGuide)
            make.top.equalTo(minTempLabel.snp.bottom).offset(20)
            make.height.equalTo(80)
            make.centerX.equalTo(maxTempLabel)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolView.snp.bottom)
            make.bottom.leading.equalTo(contentView.layoutMarginsGuide)
            make.trailing.equalTo(windView.snp.leading)
        }
    }
}
