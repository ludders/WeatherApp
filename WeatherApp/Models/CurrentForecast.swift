//
//  CurrentForecast.swift
//  WeatherApp
//
//  Created by dludlow7 on 29/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct CurrentForecast {
    var sunrise: Int?
    var sunset: Int?
    var temperature: Double?
    var windSpeed: Double?
    var windDegrees: Int?
    var description: String?
    var iconCode: String?

    public init(sunrise: Int?,
                sunset: Int?,
                temperature: Double?,
                windSpeed: Double?,
                windDegrees: Int?,
                description: String?,
                iconCode: String?) {
        self.sunrise = sunrise
        self.sunset = sunset
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.windDegrees = windDegrees
        self.description = description
        self.iconCode = iconCode
    }
}
