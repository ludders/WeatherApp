//
//  WeatherService.swift
//  WeatherApp
//
//  Created by dludlow7 on 20/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationForecastCompletion = (Result<LocationForecast, NetworkingError>) -> ()

enum NetworkingError: Error {
    case error(Int?)
}

class WeatherService {
    private var weatherAPI: WeatherAPI
    private var cache: [Location: LocationForecast] = [:]
    private var cacheUpdateDispatchGroup: DispatchGroup = DispatchGroup()
    public var savedLocations: [Location] {
        return cache.map { $0.key }
            .filter { $0.saved }
    }

    init(weatherAPI: WeatherAPI = WeatherAPI()) {
        self.weatherAPI = weatherAPI
    }

    func updateForecasts(for locations: [Location]) {
        cacheUpdateDispatchGroup = DispatchGroup()
        locations.forEach { location in
            cacheUpdateDispatchGroup.enter()
            updateForecast(for: location) { _ in
                self.cacheUpdateDispatchGroup.leave()
            }
        }
    }

    func getForecast(for location: Location, onCompletion completion: @escaping LocationForecastCompletion) {
        let getForecastWorkItem = DispatchWorkItem {
            if let cachedForecast = self.cache[location] {
                completion(.success(cachedForecast))
            } else {
                self.updateForecast(for: location, onCompletion: completion)
            }
        }
        cacheUpdateDispatchGroup.notify(queue: DispatchQueue.global(qos: .default), work: getForecastWorkItem)
    }

    fileprivate func updateForecast(for location: Location, onCompletion: LocationForecastCompletion? = nil) {
        weatherAPI.getForecastResponse(for: location.coordinate) { result in
            switch result {
            case .success(let response):
                self.cache[location] = self.createLocationForecast(using: response)
                onCompletion?(.success(self.cache[location]!))
            case .failure(let error):
                onCompletion?(.failure(error))
            }
        }
    }

    fileprivate func createLocationForecast(using response: WeatherResponse) -> LocationForecast {
        let dailyForecasts: [DailyForecast]? = response.daily?.map { dailyResponse -> DailyForecast in

            let hourlyForecasts = createHourlyForecasts(forDate: dailyResponse.dt, using: response.hourly)
            return createDailyForecast(using: dailyResponse, hourlyForecasts: hourlyForecasts)
        }
        return LocationForecast(dailyForecasts: dailyForecasts)
    }

    fileprivate func createDailyForecast(using dailyResponse: DailyWeatherResponse, hourlyForecasts: [HourlyForecast]?) -> DailyForecast {
        return DailyForecast(time: dailyResponse.dt,
                             sunrise: dailyResponse.sunrise,
                             sunset: dailyResponse.sunset,
                             symbol: SymbolString.from(code: dailyResponse.weather?.first?.icon ?? ""),
                             maxTemp: dailyResponse.temp?.max,
                             minTemp: dailyResponse.temp?.min,
                             windDeg: dailyResponse.windDeg,
                             windSpeed: dailyResponse.windSpeed,
                             description: dailyResponse.weather?.first?.description,
                             humidity: dailyResponse.humidity,
                             pressure: dailyResponse.pressure,
                             feelsLike: dailyResponse.feelsLike,
                             clouds: dailyResponse.clouds,
                             hourlyForecasts: hourlyForecasts)
    }

    fileprivate func createHourlyForecasts(forDate date: Date, using hourlyResponses: [HourlyWeatherResponse]?) -> [HourlyForecast]? {
        return hourlyResponses?.filter { hourlyResponse in
            return shouldInclude(hourlyResponse, forDate: date)
        }
        .map { hourlyResponse in
            createHourlyForecast(using: hourlyResponse)
        }
    }

    fileprivate func shouldInclude(_ hourlyResponse: HourlyWeatherResponse, forDate date: Date) -> Bool {
        //Include hourly forecasts from 0600 on the day, till 0500 the next day.
        guard let hourlyResponseDate = hourlyResponse.dt else { return false }

        let sixAM_currentDay = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: date)
        var fiveAM_nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)
        fiveAM_nextDay = Calendar.current.date(bySetting: .hour, value: 5, of: date)

        guard let lowerBoundDate = sixAM_currentDay,
              let upperBoundDate = fiveAM_nextDay else { return false }

        return hourlyResponseDate >= lowerBoundDate && hourlyResponseDate <= upperBoundDate
    }

    fileprivate func createHourlyForecast(using hourlyResponse: HourlyWeatherResponse) -> HourlyForecast {
        return HourlyForecast(date: hourlyResponse.dt ?? Date(timeIntervalSince1970: 0),
                              symbol: SymbolString.from(code: hourlyResponse.weather?.first?.icon ?? ""),
                              temp: hourlyResponse.temp,
                              windDeg: hourlyResponse.windDeg,
                              windSpeed: hourlyResponse.windSpeed,
                              description: hourlyResponse.weather?.first?.description,
                              humidity: hourlyResponse.humidity,
                              pressure: hourlyResponse.pressure,
                              feelsLike: hourlyResponse.feelsLike,
                              clouds: hourlyResponse.clouds)
    }


    func updateCache(using model: LocationModel) {
        if let index = cache.firstIndex(where: { $0.key == model.location }) {
            let element = cache.remove(at: index)
        }
        cache[model.location] = model.forecast
    }
}
