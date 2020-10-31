//
//  ForecastLocation.swift
//  WeatherApp
//
//  Created by dludlow7 on 29/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationForecast {
    public var lastUpdated: TimeInterval
    public var dailyForecasts: [DailyForecast]?
    
    public init(dailyForecasts: [DailyForecast]?) {
        self.dailyForecasts = dailyForecasts
        lastUpdated = Date().timeIntervalSince1970
    }
}

// MARK: Header View Display Formatting

//TODO: Move this out to HomeViewModel once we've changed the network calls
extension LocationForecast {
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
}

//MARK: Data Items for collection view

extension LocationForecast {
    var asDataItems: [[ForecastDataItem]] {
        return dailyForecasts?.map({ daily -> [ForecastDataItem] in
            var items = [ForecastDataItem.day(daily)]
            items.append(contentsOf: daily.hourlyForecasts?.map({ hourly -> ForecastDataItem in
                return ForecastDataItem.hourly(hourly)
            }) ?? [])
            return items
        }) ?? []
    }
}
