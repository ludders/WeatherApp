//
//  HourlyForecas.swift
//  WeatherApp
//
//  Created by dludlow7 on 08/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct HourlyForecast {
    var date: Date
    var symbol: String?
    var temp: Double?
    var windDeg: Int?
    var windSpeed: Double?

    var description: String?
    var humidity: Int?
    var pressure: Int?
    var feelsLike: Double?
    var clouds: Int?
}
