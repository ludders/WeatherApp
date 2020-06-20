//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by dludlow7 on 08/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct DailyForecast {
    var time: TimeInterval
    var symbol: String?
    var maxTemp: Double?
    var minTemp: Double?
    var windDeg: Int?
    var windSpeed: Double?

    var description: String?
    var humidity: Int?
    var pressure: Int?
    var feelsLike: FeelsLike?
    var clouds: Int?
    var hourlyForecasts: [HourlyForecast]?
}
