//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by dludlow7 on 12/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    func setup() {
        contentView.backgroundColor = UIColor(white: CGFloat.random(in: 0.1...0.7), alpha: 1)
    }
}
