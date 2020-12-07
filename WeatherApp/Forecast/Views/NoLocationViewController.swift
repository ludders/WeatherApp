//
//  NoLocationViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 30/11/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

final class NoLocationViewController: UIViewController {

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.Colours.white
        label.font = Theme.Fonts.BBC.largeSubTitle
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.text = NSLocalizedString("Search for a location", comment: "Search for a location")
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
        label.attributedText = messageLabelAttributedText
        return label
    }()

    private static var messageLabelAttributedText: NSAttributedString {
        let firstImage = UIImage(systemName: "magnifyingglass")
        let firstAttachment = NSTextAttachment(image: firstImage!)
        let secondImage = UIImage(systemName: "location")
        let secondAttachment = NSTextAttachment(image: secondImage!)
        let messageText = NSLocalizedString("Tap on the magnifying glass @! to search for a location, or use the arrow icon @! to find the weather forecast at your current location", comment: "Tap on the magnifying glass @! to search for a location, or use the arrow icon @! to find the weather forecast at your current location")
        return messageText.attributedString(with: [firstAttachment, secondAttachment], replacing: "@!")
    }

    private var roundedBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colours.bbcGrey
        view.layer.cornerRadius = 13
        return view
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return stackView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        stackView.addSubview(roundedBoxView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        view.addSubview(stackView)
        setupConstraints()
    }

    private func setupConstraints() {
        roundedBoxView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(300)
        }
    }
}
