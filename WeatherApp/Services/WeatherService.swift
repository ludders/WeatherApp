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

    func getWeatherResponse(for request: WeatherRequest,
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

    func getForecast(for request: WeatherRequest,
                     onCompletion: ((Forecast) -> ())?,
                     onFailure: (() -> ())?) {
        getWeatherResponse(for: request, onCompletion: { response in
            let current = response.current
            let forecast = Forecast(name: "Placeholder",
                                    coordinates: CLLocationCoordinate2D(latitude: response.lat ?? 0, longitude: response.lon ?? 0),
                                    currentForecast: CurrentForecast(sunrise: current?.sunrise,
                                                                     sunset: current?.sunset,
                                                                     temperature: current?.temp,
                                                                     windSpeed: current?.windSpeed,
                                                                     windDegrees: current?.windDeg,
                                                                     description: current?.weather?.first?.description,
                                                                     iconCode: current?.weather?.first?.icon))
            onCompletion?(forecast)
        }, onFailure: nil)
    }

    func buildRequestURL(for request: WeatherRequest) -> URL? {
        var urlComponents = weatherAPI.getURLComponents()
        var queryItems = request.asURLQueryItems()
        queryItems.append(URLQueryItem(name: "appid", value: WeatherAPI.key))
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

}
