//
//  File.swift
//  WeatherApp
//
//  Created by dludlow7 on 12/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

class TestCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    func setup(text: String) {
        contentView.backgroundColor = .white
        label.text = text
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
