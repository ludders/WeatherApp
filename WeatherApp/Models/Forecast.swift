//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 29/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class Forecast {
    public var lastUpdated: TimeInterval
    public var name: String?
    public var currentForecast: CurrentForecast?
//    public var dailyForecasts: [DailyForecast]
    //TODO: Add daily weather data

    public init(name: String?, currentForecast: CurrentForecast?) {
        self.name = name
        self.currentForecast = currentForecast
        lastUpdated = Date().timeIntervalSince1970
    }
}
