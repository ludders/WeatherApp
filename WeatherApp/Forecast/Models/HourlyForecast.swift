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

extension HourlyForecast {

    //TODO: This is one day ahead, fix.
    var nextDay: String? {
        return date.isAtExactly(hour: 0) ? date.nextDayAsEEE?.localizedUppercase : nil
    }

    var formattedTime: String {
        let format = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale.current)
        let hhMMFormatter = DateFormatter()
        hhMMFormatter.setLocalizedDateFormatFromTemplate(format ?? "HH:mm")
        return hhMMFormatter.string(from: date)
    }
}
