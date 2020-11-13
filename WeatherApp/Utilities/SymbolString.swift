//
//  SymbolString.swift
//  WeatherApp
//
//  Created by dludlow7 on 16/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

struct SymbolString {

    private init() {}

    private static let symbolDict: [String: String] = [
        "01d": "sun.max",
        "02d": "cloud.sun",
        "03d": "smoke",
        "04d": "cloud",
        "09d": "cloud.drizzle",
        "10d": "cloud.heavyrain",
        "11d": "cloud.bolt",
        "13d": "cloud.snow",
        "50d": "cloud.fog",
        "01n": "moon",
        "02n": "cloud.moon",
        "03n": "smoke",
        "04n": "cloud",
        "09n": "cloud.drizzle",
        "10n": "cloud.heavyrain",
        "11n": "cloud.bolt",
        "13n": "cloud.snow",
        "50n": "cloud.fog"
    ]

    static func from(code: String) -> String? {
        return symbolDict[code]
    }
}
