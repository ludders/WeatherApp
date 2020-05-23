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

    var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Menu", for: .normal)
        return button
    }()
    var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bbcWeatherLogo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexible, searchButton, shareButton], animated: true)
        return toolbar
    }()

    init() {
        super.init(frame: CGRect.zero)
    }

    func configure() {

        addSubview(menuButton)
        addSubview(titleImage)
        addSubview(toolbar)
        applyConstraints()

        toolbar.tintColor = tintColor
        menuButton.tintColor = tintColor
    }

    func applyConstraints() {
        snp.makeConstraints { make in
            if let superView = self.superview {
                make.leading.trailing.top.equalTo(superView.safeAreaLayoutGuide)
            }
            make.height.equalTo(48)
        }

        menuButton.snp.makeConstraints { make in
            make.height.leading.top.bottom.equalTo(layoutMarginsGuide).labeled("menuButtonConstraint")
        }

        titleImage.snp.makeConstraints { make in
            make.height.top.bottom.centerX.equalToSuperview().labeled("titleImageEdges")
            make.width.equalTo(120).labeled("titleImageWidth")
        }

        toolbar.snp.makeConstraints { make in
            make.height.trailing.top.bottom.equalToSuperview().labeled("toolbarEdges")
            make.leading.equalTo(titleImage.snp.trailing).labeled("toolbarLeading")
        }

        print(toolbar.frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func searchTapped() {

    }

    @objc func shareTapped() {

    }

}
