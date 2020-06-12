//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 02/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherViewModel {

    var forecast: Observable<Forecast>
    //TODO: Remove the default forecast when no longer needed
    public init(forecast: Forecast = Forecast(name: nil,
                                              coordinates: CLLocationCoordinate2D.nullIsland,
                                              currentForecast: nil,
                                              dailyForecasts: nil)) {
        self.forecast = Observable<Forecast>(forecast)
    }

    public func updateForecast() {
        let service = WeatherService()
        let request = WeatherRequest(latitude: String(forecast.value.coordinates.latitude),
                                     longitude: String(forecast.value.coordinates.longitude),
                                     units: "metric")
        service.getForecast(for: request, onCompletion: { forecast in
            self.forecast.value = forecast
        }, onFailure: nil)
    }
}
