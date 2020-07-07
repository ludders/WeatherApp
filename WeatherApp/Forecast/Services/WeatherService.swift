//
//  WeatherService.swift
//  WeatherApp
//
//  Created by dludlow7 on 20/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationForecastCompletion = Result<LocationForecast, NetworkError>
typealias WeatherResponseCompletion = Result<WeatherResponse, NetworkError>

enum NetworkError: Error {
    case error
}

class WeatherService {
    var weatherAPI: API

    init(weatherAPI: API = WeatherAPI()) {
        self.weatherAPI = weatherAPI
    }

    private func getWeatherResponse(for request: WeatherRequest, onCompletion: @escaping (WeatherResponseCompletion) -> ()) {

        guard let url = buildRequestURL(for: request) else {
            onCompletion(.failure(.error))
            return
        }

        let session = URLSession.shared
        print(url)

        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.mimeType == "application/json",
                (200...299).contains(response.statusCode) else {
                    onCompletion(.failure(.error))
                    return
            }
            guard let data = data else {
                onCompletion(.failure(.error))
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            if let weatherResponse = try? decoder.decode(WeatherResponse.self, from: data) {
                onCompletion(.success(weatherResponse))
            }
        }
        dataTask.resume()
    }

    func getLocationForecast(for request: WeatherRequest, onCompletion: @escaping (LocationForecastCompletion) -> ()) {
        getWeatherResponse(for: request, onCompletion: { result in
            switch result {
            case .success(let response):
                sleep(1)
                let locationForecast = self.buildLocationForecast(using: response)
                onCompletion(.success(locationForecast))
            case .failure(let error):
                print(error)
            }
        })
    }

    private func buildRequestURL(for request: WeatherRequest) -> URL? {
        var urlComponents = weatherAPI.getURLComponents()
        var queryItems = request.asURLQueryItems()
        queryItems.append(URLQueryItem(name: "appid", value: WeatherAPI.key))
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    private func buildLocationForecast(using response: WeatherResponse) -> LocationForecast {
        let current = response.current
        var locationForecast = LocationForecast(name: "Placeholder",
                                coordinates: CLLocationCoordinate2D(latitude: response.lat ?? 0, longitude: response.lon ?? 0),
                                currentForecast: CurrentForecast(sunrise: current?.sunrise,
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
