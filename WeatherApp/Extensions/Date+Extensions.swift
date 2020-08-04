//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by dludlow7 on 29/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

extension Date {
    func isAtExactly(hour: Int) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        var hourComponent = DateComponents()
        hourComponent.hour = hour
        return calendar.date(self, matchesComponents: hourComponent)
    }

    var nextDayAsEEE: String? {
        let calendar = Calendar(identifier: .gregorian)
        guard let nextDaysDate = calendar.date(byAdding: .day, value: 1, to: self) else { return nil }
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEE")
        return formatter.string(from: nextDaysDate)
    }

    func formattedAs(_ template: String) -> String {
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = format
        return customFormatter.string(from: self)
    }
}
