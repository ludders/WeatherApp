//
//  WeatherService.swift
//  WeatherApp
//
//  Created by dludlow7 on 20/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class WeatherService {
    var weatherAPI: API

    init(weatherAPI: API = WeatherAPI()) {
        self.weatherAPI = weatherAPI
    }

    func getWeatherResponse(for weatherRequest: WeatherRequest,
                            onCompletion: ((WeatherResponse) -> ())?,
                            onFailure: (() -> ())?) {

        guard let url = buildRequestURL(for: weatherRequest) else {
            onFailure?()
            return
        }

        let session = URLSession.shared

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
            if let jsonData = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                onCompletion?(jsonData)
            }
        }
        dataTask.resume()
    }
}
