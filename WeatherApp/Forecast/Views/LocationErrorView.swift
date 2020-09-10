//
//  LocationErrorView.swift
//  WeatherApp
//
//  Created by dludlow7 on 14/08/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class LocationErrorView: UIView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.Colours.white
        label.font = Theme.Fonts.BBC.largeSubTitle
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.Colours.silver
        label.font = Theme.Fonts.BBC.body
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    var tryAgainButton: Button = {
        let button = Button()
        button.tintColor = Theme.Colours.white
        button.titleLabel?.font = Theme.Fonts.BBC.body
        button.contentHorizontalAlignment = .center
        return button
    }()
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colours.bbcGrey
        return view
    }()
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return stackView
    }()

    init() {
        super.init(frame: CGRect.zero)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        stackView.addSubview(backgroundView)
        titleLabel.text = NSLocalizedString("No Internet Connection", comment: "No Internet Connection")
        stackView.addArrangedSubview(titleLabel)
        messageLabel.text = NSLocalizedString("You need a WiFi or Mobile Data connection in order to access the latest weather forecasts", comment: "You need a WiFi or Mobile Data connection in order to access the latest weather forecasts")
        stackView.addArrangedSubview(messageLabel)
        tryAgainButton.setTitle(NSLocalizedString("Try Again", comment: "Try Again"), for: .normal)
        stackView.addArrangedSubview(tryAgainButton)
        addSubview(stackView)
        setupConstraints()
    }

    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(300)
        }
    }
}
