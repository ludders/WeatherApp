//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by dludlow7 on 29/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

extension Date {
    var isAtMidnight: Bool {
        return self.isAtExactly(hour: 0)
    }

    private func isAtExactly(hour: Int) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        var hourComponent = DateComponents()
        hourComponent.hour = hour
        return calendar.date(self, matchesComponents: hourComponent)
    }

    func formattedAs(_ template: String) -> String {
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = format
        return customFormatter.string(from: self)
    }
}
