//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 02/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class WeatherViewModel {

    var forecast: Forecast

    //TODO: Remove the default forecast when no longer needed
    public init(forecast: Forecast = Forecast(name: nil, currentForecast: nil)) {
        self.forecast = forecast
    }

    var lastUpdateDisplayText: String {
        let seconds = Int(Date().timeIntervalSince1970 - forecast.lastUpdated)
        let days = seconds/86400
        let hours = seconds/3600
        let minutes = seconds/60

        if days >= 1 {
            return days == 1 ? String(format: NSLocalizedString("%d day ago", comment: "%d day ago"), days) :
                String(format: NSLocalizedString("%d days ago", comment: "%d days ago"), days)
        } else if hours >= 1 {
            return hours == 1 ? String(format: NSLocalizedString("%d hour ago", comment: "%d hour ago"), hours) :
                String(format: NSLocalizedString("%d hours ago", comment: "%d hours ago"), hours)
        } else if minutes >= 1 {
            return minutes == 1 ? String(format: NSLocalizedString("%d minute ago", comment: "%d minute ago"), minutes) :
                String(format: NSLocalizedString("%d minutes ago", comment: "%d minutes ago"), minutes)
        } else {
            return "a moment ago"
        }
    }

    var sunriseDisplayText: String {
        guard let sunrise = forecast.currentForecast?.sunrise else {
            return "--:--"
        }
        return DateFormatter.localizedString(from: Date(timeIntervalSince1970: Double(sunrise)), dateStyle: .none, timeStyle: .short)
    }

    var sunsetDisplayText: String {
        guard let sunset = forecast.currentForecast?.sunset else {
            return "--:--"
        }
        return DateFormatter.localizedString(from: Date(timeIntervalSince1970: Double(sunset)), dateStyle: .none, timeStyle: .short)
    }
}
