//
//  WeatherService.swift
//  WeatherApp
//
//  Created by dludlow7 on 20/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationForecastCompletion = Result<LocationForecast, NetworkingError>

enum NetworkingError: Error {
    case error(Int?)
}

class WeatherService {
    var weatherAPI: WeatherAPI

    init(weatherAPI: WeatherAPI = WeatherAPI()) {
        self.weatherAPI = weatherAPI
    }

    func getLocationForecast(for location: LocationModel, onCompletion: @escaping (LocationForecastCompletion) -> ()) {
        weatherAPI.getWeatherResponse(for: location.coordinates, onCompletion: { result in
            switch result {
            case .success(let response):
                let locationForecast = self.buildLocationForecast(using: response)
                onCompletion(.success(locationForecast))
            case .failure(let error):
                print(error)
            }
        })
    }

    private func buildLocationForecast(using response: WeatherResponse) -> LocationForecast {
        let current = response.current
        var locationForecast = LocationForecast(currentForecast: CurrentForecast(sunrise: current?.sunrise,
                                                                 sunset: current?.sunset,
                                                                 temperature: current?.temp,
                                                                 windSpeed: current?.windSpeed,
                                                                 windDegrees: current?.windDeg,
                                                                 description: current?.weather?.first?.description,
                                                                 iconCode: current?.weather?.first?.icon), dailyForecasts: nil)

        func buildDailyForecasts() -> [DailyForecast]? {
            return response.daily?.map({ day -> DailyForecast in
                let hourlyForecasts = response.hourly?.filter({ hour -> Bool in
                    //Include hourly forecasts from 0600 each day, till 0500 the next day.
                    guard let dayDate = day.dt,
                        let hourDate = hour.dt else { return false }

                    let calendar = Calendar.current
                    let lowerLimitDate = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: dayDate)
                    var upperLimitDate = calendar.date(byAdding: .day, value: 1, to: dayDate)
                    upperLimitDate = calendar.date(bySetting: .hour, value: 5, of: dayDate)

                    guard let lower = lowerLimitDate, let upper = upperLimitDate else { return false }

                    return hourDate >= lower && hourDate <= upper })
                    .map({ hour -> HourlyForecast in
                        return HourlyForecast(date: hour.dt ?? Date(timeIntervalSince1970: 0),
                                              symbol: SymbolString.from(code: hour.weather?.first?.icon ?? ""),
                                              temp: hour.temp,
                                              windDeg: hour.windDeg,
                                              windSpeed: hour.windSpeed,
                                              description: hour.weather?.first?.description,
                                              humidity: hour.humidity,
                                              pressure: hour.pressure,
                                              feelsLike: hour.feelsLike,
                                              clouds: hour.clouds)
                    })

                return DailyForecast(time: day.dt ?? Date(timeIntervalSince1970: 0),
                                     sunrise: day.sunrise,
                                     sunset: day.sunset,
                                     symbol: SymbolString.from(code: day.weather?.first?.icon ?? ""),
                                     maxTemp: day.temp?.max,
                                     minTemp: day.temp?.min,
                                     windDeg: day.windDeg,
                                     windSpeed: day.windSpeed,
                                     description: day.weather?.first?.description,
                                     humidity: day.humidity,
                                     pressure: day.pressure,
                                     feelsLike: day.feelsLike,
                                     clouds: day.clouds,
                                     hourlyForecasts: hourlyForecasts)
            })
        }

        locationForecast.dailyForecasts = buildDailyForecasts()
        return locationForecast
    }
}
