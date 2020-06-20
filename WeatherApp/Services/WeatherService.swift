//
//  WeatherService.swift
//  WeatherApp
//
//  Created by dludlow7 on 20/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherService {
    var weatherAPI: API

    init(weatherAPI: API = WeatherAPI()) {
        self.weatherAPI = weatherAPI
    }

    private func getWeatherResponse(for request: WeatherRequest,
                            onCompletion: ((WeatherResponse) -> ())?,
                            onFailure: (() -> ())?) {

        guard let url = buildRequestURL(for: request) else {
            onFailure?()
            return
        }

        let session = URLSession.shared
        print(url)

        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.mimeType == "application/json",
                (200...299).contains(response.statusCode) else {
                    onFailure?()
                    return
            }
            guard let data = data else {
                onFailure?()
                return
            }
            if let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                onCompletion?(weatherResponse)
            }
        }
        dataTask.resume()
    }

    func getLocationForecast(for request: WeatherRequest,
                     onCompletion: ((LocationForecast) -> ())?,
                     onFailure: (() -> ())?) {
        getWeatherResponse(for: request, onCompletion: { response in
            let locationForecast = self.buildLocationForecast(using: response)
            onCompletion?(locationForecast)
        }, onFailure: nil)
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
                let hourlyForecasts = response.hourly?.filter({ hourly -> Bool in
                    let calendar = Calendar(identifier: .gregorian)
                    let dailyDate = Date(timeIntervalSince1970: TimeInterval(hourly.dt ?? 0))
                    let hourlyDate = Date(timeIntervalSince1970: TimeInterval(day.dt ?? 1))
                    return calendar.compare(dailyDate, to: hourlyDate, toGranularity: .day) == .orderedSame })
                    .map({ hour -> HourlyForecast in
                        return HourlyForecast(time: TimeInterval(hour.dt ?? 0),
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

                return DailyForecast(time: TimeInterval(day.dt ?? 0),
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
