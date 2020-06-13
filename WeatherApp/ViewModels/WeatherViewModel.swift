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
    var locationForecast: Observable<LocationForecast>
    //TODO: Remove the default forecast when no longer needed
    public init(model: LocationForecast = LocationForecast(name: nil,
                                              coordinates: CLLocationCoordinate2D.nullIsland,
                                              currentForecast: nil,
                                              dailyForecasts: nil)) {
        self.locationForecast = Observable<LocationForecast>(model)
    }

    public func updateForecast() {
        let service = WeatherService()
        let request = WeatherRequest(latitude: String(locationForecast.value.coordinates.latitude),
                                     longitude: String(locationForecast.value.coordinates.longitude),
                                     units: "metric")
        service.getLocationForecast(for: request, onCompletion: { locationForecast in
            self.locationForecast.value = locationForecast
        }, onFailure: nil)
    }

    var selectedDayIndex = 1
    var numberOfForecastItems: Int {
        return 1 + (locationForecast.value.dailyForecasts?[selectedDayIndex].hourlyForecasts?.count ?? 0)
    }
}