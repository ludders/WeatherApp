//
//  HeaderView.swift
//  WeatherApp
//
//  Created by dludlow7 on 21/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

class HeaderView: UIView {

    weak var delegate: HeaderViewDelegate?

    private var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Menu", comment: "Menu"), for: .normal)
        return button
    }()
    private var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bbcWeatherLogo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    private var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        return button
    }()
    private var locationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside)
        return button
    }()

    func setupView() {
        menuButton.tintColor = tintColor
        addSubview(menuButton)
        addSubview(titleImage)
        buttonsStackView.addArrangedSubview(searchButton)
        buttonsStackView.addArrangedSubview(locationButton)
        addSubview(buttonsStackView)
        applyConstraints()
    }

    private func applyConstraints() {

        layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        snp.makeConstraints { make in
            if let superView = self.superview {
                make.leading.trailing.top.equalTo(superView.safeAreaLayoutGuide)
            }
            make.height.equalTo(48)
        }

        menuButton.snp.makeConstraints { make in
            make.height.leading.top.bottom.equalTo(layoutMarginsGuide)
        }

        titleImage.snp.makeConstraints { make in
            make.height.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(120)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.height.trailing.top.bottom.equalTo(layoutMarginsGuide)
        }
    }

    @objc private func didTapSearch() {
        delegate?.didTapSearch()
    }

    @objc private func didTapLocation() {
        delegate?.didTapLocation()
    }
}

protocol HeaderViewDelegate: AnyObject {
    func didTapSearch()
    func didTapLocation()
}
