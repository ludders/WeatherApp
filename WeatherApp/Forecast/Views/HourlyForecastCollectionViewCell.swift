//
//  HourlyForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by dludlow7 on 12/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class HourlyForecastCollectionViewCell: UICollectionViewCell {
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
    private var showDayLabel: Bool = false
    private lazy var dayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = Theme.Fonts.BBC.subhead
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
        view.label.textColor = Theme.Colours.black
        return view
    }()

    func configure(with viewModel: HourlyForecastCellViewModel) {
        timeView.text = viewModel.time
        dayLabel.text = viewModel.nextDay
        showDayLabel = viewModel.nextDay != nil
        symbolView.image = viewModel.image
        temperatureLabel.text = viewModel.temp
        cloudPercentageLabel.text = viewModel.cloudPercentage
        windView.degrees = viewModel.windDegrees
        windView.label.text = viewModel.windSpeed

        cloudStackView.addArrangedSubview(cloudSymbolView)
        cloudStackView.addArrangedSubview(cloudPercentageLabel)

        contentView.addSubview(timeView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(symbolView)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(cloudStackView)
        contentView.addSubview(windView)
        contentView.addSubview(verticalSeparatorView)

        setupConstraints()
    }

    private func setupConstraints() {

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

        if showDayLabel {
            dayLabel.snp.makeConstraints { make in
                make.bottom.centerX.equalTo(timeView)
                make.top.greaterThanOrEqualTo(timeView.snp.firstBaseline).offset(10)
            }
        }
    }

    override func prepareForReuse() {
        dayLabel.removeFromSuperview()
        showDayLabel = false
        super.prepareForReuse()
    }
}
