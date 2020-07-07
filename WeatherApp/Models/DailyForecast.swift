//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by dludlow7 on 08/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct DailyForecast {
    var time: Date
    var sunrise: Date?
    var sunset: Date?
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

extension DailyForecast {
    var sunriseDisplayText: String {
        guard let sunrise = sunrise else {
            return "--:--"
        }
        return DateFormatter.localizedString(from: sunrise, dateStyle: .none, timeStyle: .short)
    }

    var sunsetDisplayText: String {
        guard let sunset = sunset else {
            return "--:--"
        }
        return DateFormatter.localizedString(from: sunset, dateStyle: .none, timeStyle: .short)
    }
}
