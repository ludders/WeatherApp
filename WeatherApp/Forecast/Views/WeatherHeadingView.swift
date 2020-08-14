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
        button.tintColor = Theme.Colours.silver
        return button
    }()
    var refreshLabel: UILabel = {
        let label = UILabel()
        let formatString = NSLocalizedString("%d minutes ago", comment: "%d minutes ago")
        label.text = String.localizedStringWithFormat(formatString, 5)
        label.font = Theme.Fonts.BBC.footnote
        label.textColor = Theme.Colours.silver
        return label
    }()
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.largeTitle50
        label.textColor = Theme.Colours.white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.7
        return label
    }()
    var addLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.square"), for: .normal)
        button.imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.tintColor = Theme.Colours.white
        return button
    }()
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.largeSubTitle
        label.textColor = Theme.Colours.white
        return label
    }()
    var sunriseLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.footnote
        label.textColor = Theme.Colours.white
        return label
    }()
    var sunsetLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.footnote
        label.textColor = Theme.Colours.silver
        return label
    }()
    var sunriseImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "sunrise.fill"))
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .body)
        imageView.tintColor = Theme.Colours.white
        return imageView
    }()
    var sunTimesView: UIStackView?

    init() {
        super.init(frame: CGRect.zero)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("No storyboards!")
    }

    private func setupSubViews() {
        addSubview(refreshButton)
        addSubview(refreshLabel)
        addSubview(locationLabel)
        addSubview(addLocationButton)
        addSubview(subtitleLabel)
        setupSunTimesView()
        setupConstraints()
    }

    private func setupSunTimesView() {
        sunTimesView = UIStackView(arrangedSubviews: [sunriseImageView, sunriseLabel, sunsetLabel])
        sunTimesView?.alignment = .firstBaseline
        sunTimesView?.distribution = .fillProportionally
        sunTimesView?.axis = .horizontal
        sunTimesView?.spacing = 10
        addSubview(sunTimesView!)
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
        sunTimesView?.snp.makeConstraints({ make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.firstBaseline.equalTo(subtitleLabel.snp.firstBaseline)
        })
    }

    func configure(with locationModel: LocationModel) {
        DispatchQueue.main.async {
            self.locationLabel.text = locationModel.location.name
            self.refreshLabel.text = locationModel.forecast?.lastUpdateDisplayText
        }
    }
}
