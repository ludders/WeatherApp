//
//  DayCollectionViewCell.swift
//  WeatherApp
//
//  Created by dludlow7 on 12/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

enum DayCellStyle {
    case frontCell
    case middleCell
    case endCell
}

class DayCollectionViewCell: UICollectionViewCell {
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.body
        label.textColor = Theme.Colours.white
        return label
    }()
    let iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Theme.Colours.white
        return imageView
    }()
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.body
        label.textColor = Theme.Colours.white
        return label
    }()
    let minTempLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.BBC.body
        label.textColor = Theme.Colours.silver
        return label
    }()
    var topBar = UIView()
    var bottomBar = UIView()
    let leftCornerMask = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
    let rightCornerMask = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)

    func configure(with viewModel: DayCollectionViewCellViewModel) {
        contentView.backgroundColor = Theme.Colours.bbcGrey
        dayLabel.text = viewModel.dayName
        contentView.addSubview(dayLabel)
        iconView.image = viewModel.image
        contentView.addSubview(iconView)
        maxTempLabel.text = viewModel.maxTemp
        contentView.addSubview(maxTempLabel)
        minTempLabel.text = viewModel.minTemp
        contentView.addSubview(minTempLabel)
        isSelected = viewModel.isSelected

        configureCornerStyling(with: viewModel.cellStyle)

        if isSelected {
            configureBottomBar()
        } else {
            configureTopBar()
        }
        
        setupConstraints()
    }

    private func configureCornerStyling(with style: DayCellStyle) {
        contentView.layer.masksToBounds = true
        switch style {
        case .frontCell:
            contentView.layer.maskedCorners = leftCornerMask
            contentView.layer.cornerRadius = 10
        case .endCell:
            contentView.layer.maskedCorners = rightCornerMask
            contentView.layer.cornerRadius = 10
        default:
            break
        }
    }

    private func configureBottomBar() {
        bottomBar.backgroundColor = Theme.Colours.bbcGreen
        contentView.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.bottom.leading.trailing.equalTo(contentView)
        }
    }

    private func configureTopBar() {
        topBar.backgroundColor = Theme.Colours.bbcRed
        contentView.addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.top.leading.trailing.equalTo(contentView)
        }
    }

    func setupConstraints() {
        contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        dayLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.layoutMargins)
        }
        iconView.snp.makeConstraints { make in
            make.top.equalTo(maxTempLabel)
            make.leading.equalTo(contentView.layoutMargins)
            make.bottom.equalTo(minTempLabel)
            make.trailing.equalTo(minTempLabel.snp.leading).offset(-10)
        }
        maxTempLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.layoutMargins)
            make.centerY.equalToSuperview()
        }
        minTempLabel.snp.makeConstraints { make in
            make.leading.equalTo(maxTempLabel)
            make.top.equalTo(maxTempLabel.snp.bottom).offset(5)
            make.trailing.equalTo(contentView.layoutMargins)
        }

    }

    override func prepareForReuse() {
        contentView.layer.maskedCorners = []
        topBar.removeFromSuperview()
        bottomBar.removeFromSuperview()
    }
}
