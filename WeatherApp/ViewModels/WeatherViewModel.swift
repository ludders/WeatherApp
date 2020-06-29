//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 02/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

typealias UpdateForecastCompletion = Result<Bool, NetworkError>

class WeatherViewModel {
    private(set) var locationForecast: Observable<LocationForecast>
    var selectedDayIndex: Observable<Int>
    //TODO: Remove the default forecast when no longer needed
    public init(model: LocationForecast = LocationForecast(name: nil,
                                              coordinates: CLLocationCoordinate2D.nullIsland,
                                              currentForecast: nil,
                                              dailyForecasts: nil)) {
        self.locationForecast = Observable<LocationForecast>(model)
        self.selectedDayIndex = Observable<Int>(0)
    }

    var forecastDataItems: [[ForecastDataItem]] = [[]]

    public func updateForecast(onCompletion: @escaping (UpdateForecastCompletion) -> ()) {
        let service = WeatherService()
        let request = WeatherRequest(latitude: String(locationForecast.value.coordinates.latitude),
                                     longitude: String(locationForecast.value.coordinates.longitude),
                                     units: "metric")

        service.getLocationForecast(for: request) { result in
            switch result {
            case .success(let forecast):
                sleep(1)
                self.locationForecast.value = forecast
                self.forecastDataItems = forecast.asDataItems
                onCompletion(.success(true))
            case .failure(let error):
                print(error)
                onCompletion(.failure(error))
            }
        }
    }
}

enum ForecastDataItem {
    case day(DailyForecast)
    case hourly(HourlyForecast)
}
