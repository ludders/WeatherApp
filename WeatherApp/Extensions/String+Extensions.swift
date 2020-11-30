//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by dludlow7 on 28/11/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

extension String {
    var asDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        return formatter.date(from: self)
    }
}
