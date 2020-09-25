//
//  LocationView.swift
//  WeatherApp
//
//  Created by dludlow7 on 25/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

final class LocationView: UIView {

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.largeTitle50
        label.textColor = Theme.Colours.white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.7
        return label
    }()

    var addLocationButton: Button = {
        let button = Button(type: .system)
        button.imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "plus.square"), for: .normal)
        button.tintColor = Theme.Colours.white
        return button
    }()

    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.largeSubTitleItalic
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
        let imageView = UIImageView()
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .body)
        imageView.image = UIImage(systemName: "sunrise.fill")
        imageView.tintColor = Theme.Colours.white
        return imageView
    }()

    lazy var sunTimesView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sunriseImageView, sunriseLabel, sunsetLabel])
        stackView.alignment = .firstBaseline
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    let forecastflowLayout: UICollectionViewFlowLayout
    let dayFlowLayout: UICollectionViewFlowLayout

    lazy var forecastCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: forecastflowLayout)
        collectionView.register(DailyForecastCollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        collectionView.register(HourlyForecastCollectionViewCell.self, forCellWithReuseIdentifier: "hourCell")
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = Theme.Colours.black
        forecastflowLayout.scrollDirection = .horizontal
        return collectionView
    }()

    lazy var dayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayFlowLayout)
        collectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "dayCollectionViewCell")
        dayFlowLayout.scrollDirection = .horizontal
        collectionView.backgroundColor = Theme.Colours.black
        dayFlowLayout.scrollDirection = .horizontal
        return collectionView
    }()

    private var shouldHideForecast = false {
        didSet {
            hideForecast(hide: shouldHideForecast)
        }
    }

    init(forecastFlowLayout: UICollectionViewFlowLayout,
         dayFlowLayout: UICollectionViewFlowLayout) {
        self.forecastflowLayout = forecastFlowLayout
        self.dayFlowLayout = dayFlowLayout
        super.init(frame: CGRect.zero)
        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        addSubview(titleLabel)
        addSubview(addLocationButton)
        addSubview(subtitleLabel)
        addSubview(sunTimesView)
        addSubview(forecastCollectionView)
        addSubview(dayCollectionView)
        addSubview(sunTimesView)
    }

    //MARK: Constraints

    func setupConstraints() {
        layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide).offset(16)
            make.leading.equalTo(layoutMarginsGuide)
        }
        addLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(layoutMarginsGuide)
            make.centerY.equalTo(titleLabel)
        }
        addLocationButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        sunTimesView.snp.makeConstraints { make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.firstBaseline.equalTo(subtitleLabel.snp.firstBaseline)
        }
        forecastCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.width.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(dayCollectionView.snp.top).offset(-10)
        }
        dayCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    func configure(for state: LocationViewState) {
        switch state {
            case .loading:
                shouldHideForecast = true
            case .loaded(let model):
                updateViews(with: model)
                shouldHideForecast = false
            case .error:
                shouldHideForecast = true
        }
    }

    func updateViews(with model: LocationModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.location.name //TODO: This title can be updated seperately as we already know this before making a network call.
            self.forecastCollectionView.reloadData()
            self.dayCollectionView.reloadData()
        }
    }

    private func hideForecast(hide: Bool) {
        DispatchQueue.main.async {
            self.addLocationButton.isHidden = hide
            self.subtitleLabel.isHidden = hide
            self.sunTimesView.isHidden = hide
            self.forecastCollectionView.isHidden = self.shouldHideForecast
            self.dayCollectionView.isHidden = self.shouldHideForecast
        }
    }
}


