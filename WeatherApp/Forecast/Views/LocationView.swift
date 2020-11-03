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

    var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = Theme.Fonts.BBC.largeTitle50
        textField.textColor = Theme.Colours.white
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 30.0
        textField.returnKeyType = .done
        textField.keyboardAppearance = .dark
        textField.autocorrectionType = .no
        return textField
    }()

    var addLocationButton: Button = {
        let button = Button(type: .system)
        button.imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "plus.square"), for: .normal)
        button.tintColor = Theme.Colours.white
        return button
    }()

    var addLocationOKButton: Button = {
        let button = Button(type: .system)
        button.imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = Theme.Colours.bbcGreen
        return button
    }()

    var addLocationCancelButton: Button = {
        let button = Button(type: .system)
        button.imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = Theme.Colours.bbcRed
        return button
    }()

    lazy var forecastContainerView: UIView = {
        let view = UIView()
        view.addSubview(subtitleLabel)
        view.addSubview(sunTimesView)
        view.addSubview(forecastCollectionView)
        view.addSubview(dayCollectionView)
        view.isUserInteractionEnabled = true
        return view
    }()

    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.largeSubTitleItalic
        label.textColor = Theme.Colours.white
        return label
    }()

    lazy var sunTimesView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sunriseImageView, sunriseLabel, sunsetLabel])
        stackView.alignment = .firstBaseline
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    var sunriseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .body)
        imageView.image = UIImage(systemName: "sunrise.fill")
        imageView.tintColor = Theme.Colours.white
        return imageView
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

    let forecastflowLayout: UICollectionViewFlowLayout
    let dayFlowLayout: UICollectionViewFlowLayout

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
        addSubview(titleTextField)
        addSubview(addLocationButton)
        addSubview(addLocationOKButton)
        addSubview(addLocationCancelButton)
        addSubview(forecastContainerView)
    }

    //MARK: Constraints

    func setupConstraints() {
        layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0)

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide).offset(16)
            make.leading.equalTo(layoutMarginsGuide)
            make.height.equalTo(60)
        }
        addLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(titleTextField.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(layoutMarginsGuide)
            make.centerY.equalTo(titleTextField)
        }
        addLocationButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        addLocationOKButton.snp.makeConstraints { make in
            make.leading.equalTo(titleTextField.snp.trailing).offset(8)
            make.centerY.equalTo(titleTextField)
        }
        addLocationOKButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        addLocationCancelButton.snp.makeConstraints { make in
            make.leading.equalTo(addLocationOKButton.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualTo(layoutMarginsGuide)
            make.centerY.equalTo(titleTextField)
        }
        addLocationCancelButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        forecastContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide)
            make.height.equalTo(40)
            make.top.equalToSuperview()
        }
        sunTimesView.snp.makeConstraints { make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.firstBaseline.equalTo(subtitleLabel.snp.firstBaseline)
        }
        forecastCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.width.equalToSuperview()
            make.bottom.equalTo(dayCollectionView.snp.top).offset(-10)
        }
        dayCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.bottom.equalToSuperview()
        }
    }

    func configure(for state: LocationViewState) {
        switch state {
            case .loading:
                disableEdit()
                hideForecast(true)
            case .loaded(let model):
                updateViews(with: model)
                disableEdit()
                hideForecast(false)
            case .editing:
                enableEdit()
            case .error:
                //TODO: Show error display here!!
                hideForecast(true)
        }
    }

    func updateViews(with model: LocationModel) {
        DispatchQueue.main.async {
            self.titleTextField.text = model.location.name
            self.addLocationButton.isHidden = model.location.saved
            self.forecastCollectionView.reloadData()
            self.dayCollectionView.reloadData()
            print(UIApplication.shared.currentWindow?.value(forKey: "_autolayoutTrace"))
        }
    }

    private func hideForecast(_ hide: Bool) {
        DispatchQueue.main.async {
            self.subtitleLabel.isHidden = hide
            self.sunTimesView.isHidden = hide
            self.forecastCollectionView.isHidden = hide
            self.dayCollectionView.isHidden = hide
        }
    }

    private func enableEdit() {
        DispatchQueue.main.async {
            self.titleTextField.isEnabled = true
            self.titleTextField.becomeFirstResponder()
            self.addLocationButton.isHidden = true
            self.addLocationOKButton.isHidden = false
            self.addLocationCancelButton.isHidden = false
        }
    }

    private func disableEdit() {
        DispatchQueue.main.async {
            self.titleTextField.isEnabled = false
            self.titleTextField.resignFirstResponder()
            self.addLocationOKButton.isHidden = true
            self.addLocationCancelButton.isHidden = true
        }
    }
}

