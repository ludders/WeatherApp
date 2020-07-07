//
//  Double+Extensions.swift
//  WeatherApp
//
//  Created by dludlow7 on 26/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

extension Double {
    var asTemperatureString: String {
        return String(Int(self.rounded())) + "°"
    }
}
