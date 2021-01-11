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

    private var menuButton: Button = {
        let button = Button(type: .system)
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
    private var searchButton: Button = {
        let button = Button(type: .custom)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()
    private var locationButton: Button = {
        let button = Button(type: .custom)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        return button
    }()

    func setupView() {
        tintColor = Theme.Colours.white
        menuButton.tintColor = tintColor
        addSubview(menuButton)
        addSubview(titleImage)
        buttonsStackView.addArrangedSubview(searchButton)
        buttonsStackView.addArrangedSubview(locationButton)
        addSubview(buttonsStackView)
        addActions()
        applyConstraints()
    }

    private func addActions() {
        searchButton.onTouchUpInside { [weak self] in
            self?.delegate?.didTapSearch()
        }
        locationButton.onTouchUpInside { [weak self] in
            self?.delegate?.didTapLocation()
        }
    }



    private func applyConstraints() {
        snp.makeConstraints { make in
            if let superView = self.superview {
                make.leading.trailing.top.equalTo(superView.safeAreaLayoutGuide)
            }
            make.height.equalTo(50)
        }

        menuButton.snp.makeConstraints { make in
            make.leading.top.equalTo(layoutMarginsGuide)
        }

        titleImage.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(120)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(menuButton.titleLabel!.snp.top)
        }
    }
}

protocol HeaderViewDelegate: AnyObject {
    func didTapSearch()
    func didTapLocation()}
