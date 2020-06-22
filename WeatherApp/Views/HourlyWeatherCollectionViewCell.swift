//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by dludlow7 on 12/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    private var verticalSeparatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Theme.Colours.white
        return view
    }()
    private var timeView: UILabel = {
        let label = UILabel(frame: .zero)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = Theme.Fonts.BBC.largeTitle30
        label.textColor = Theme.Colours.silver
        label.textAlignment = .center
        return label
    }()
    private var symbolView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.tintColor = Theme.Colours.white
        return view
    }()
    private var temperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = Theme.Fonts.BBC.largeTitle30
        label.textColor = Theme.Colours.white
        label.textAlignment = .center
        return label
    }()
    private var cloudStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    private var cloudSymbolView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "smoke.fill"))
        imageView.tintColor = Theme.Colours.silver
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var cloudPercentageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Theme.Fonts.BBC.footnote
        label.textColor = Theme.Colours.silver
        label.textAlignment = .center
        return label
    }()
    private var windView: WindIconView = {
        let view = WindIconView()
        view.contentMode = .scaleAspectFit
        view.tintColor = Theme.Colours.white
        return view
    }()

    func configure(with forecast: HourlyForecast) {
        let format = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale.current)
        let hhMMFormatter = DateFormatter()
        hhMMFormatter.setLocalizedDateFormatFromTemplate(format ?? "HH:mm")
        let date = Date(timeIntervalSince1970: forecast.time)
        timeView.text = hhMMFormatter.string(from: date)
        symbolView.image = UIImage(systemName: forecast.symbol ?? "")
        temperatureLabel.text = String(Int(forecast.temp?.rounded() ?? 0)) + "°"
        cloudPercentageLabel.text = String(forecast.clouds ?? 0) + "%"
        cloudStackView.addArrangedSubview(cloudSymbolView)
        cloudStackView.addArrangedSubview(cloudPercentageLabel)
        windView.degrees = forecast.windDeg ?? 0
        windView.label.text = String(Int(forecast.windSpeed ?? 0))

        contentView.addSubview(timeView)
        contentView.addSubview(symbolView)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(cloudStackView)
        contentView.addSubview(windView)
        contentView.addSubview(verticalSeparatorView)

        setupConstraints()
    }

    func setupConstraints() {

        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)

        timeView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height).dividedBy(5)
            make.top.leading.trailing.width.equalTo(contentView.layoutMarginsGuide)
        }
        symbolView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height).dividedBy(5)
            make.leading.trailing.width.equalTo(contentView.layoutMarginsGuide)
            make.top.equalTo(timeView.snp.bottom)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height).dividedBy(5)
            make.leading.trailing.width.equalTo(contentView.layoutMarginsGuide)
            make.top.equalTo(symbolView.snp.bottom)
        }
        cloudStackView.snp.makeConstraints { make in
            make.height.equalTo(contentView.layoutMarginsGuide.snp.width)
            make.leading.trailing.width.equalTo(contentView.layoutMarginsGuide)
            make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
        }
        windView.snp.makeConstraints { make in
            make.height.equalTo(contentView.layoutMarginsGuide.snp.width)
            make.bottom.leading.trailing.width.equalTo(contentView.layoutMarginsGuide)
        }
        verticalSeparatorView.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(contentView)
            make.trailing.equalTo(verticalSeparatorView.snp.leading).offset(1)
        }
    }
}
