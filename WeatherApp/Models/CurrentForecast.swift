//
//  CurrentForecast.swift
//  WeatherApp
//
//  Created by dludlow7 on 29/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct CurrentForecast {
    var sunrise: Date?
    var sunset: Date?
    var temperature: Double?
    var windSpeed: Double?
    var windDegrees: Int?
    var description: String?
    var iconCode: String?
}
