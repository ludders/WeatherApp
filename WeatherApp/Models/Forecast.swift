//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 29/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

struct Forecast {
    public var lastUpdated: TimeInterval
    public var name: String?
    public var coordinates: CLLocationCoordinate2D
    public var currentForecast: CurrentForecast?
    public var dailyForecasts: [DailyForecast]?
    
    public init(name: String?,
                coordinates: CLLocationCoordinate2D,
                currentForecast: CurrentForecast?,
                dailyForecasts: [DailyForecast]?) {
        self.name = name
        self.coordinates = coordinates
        self.currentForecast = currentForecast
        self.dailyForecasts = dailyForecasts
        lastUpdated = Date().timeIntervalSince1970
    }
}

extension Forecast {
    var lastUpdateDisplayText: String {
        let seconds = Int(Date().timeIntervalSince1970 - self.lastUpdated)
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
            return NSLocalizedString("a moment ago", comment: "a moment ago")
        }
    }

    var sunriseDisplayText: String {
        guard let sunrise = self.currentForecast?.sunrise else {
            return "--:--"
        }
        return DateFormatter.localizedString(from: Date(timeIntervalSince1970: Double(sunrise)), dateStyle: .none, timeStyle: .short)
    }

    var sunsetDisplayText: String {
        guard let sunset = self.currentForecast?.sunset else {
            return "--:--"
        }
        return DateFormatter.localizedString(from: Date(timeIntervalSince1970: Double(sunset)), dateStyle: .none, timeStyle: .short)
    }
}
