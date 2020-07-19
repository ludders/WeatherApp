//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by dludlow7 on 18/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import CoreLocation
import Foundation

typealias WeatherResponseCompletion = Result<WeatherResponse, NetworkingError>

struct WeatherAPI: API {
    var scheme: String = "https"
    var host: String = "api.openweathermap.org"
    var path: String = "/data/2.5/onecall"
    static let key = "e98f45a3667d7ec23c10d818ae358583"

    func getWeatherResponse(for coordinates: CLLocationCoordinate2D, onCompletion: @escaping (WeatherResponseCompletion) -> ()) {
        let parameters = WeatherRequestParameters(latitude: String(coordinates.latitude),
                                                  longitude: String(coordinates.longitude),
                                                  units: "metric")
        guard let url = buildRequestURL(using: parameters) else {
            onCompletion(.failure(.error(nil)))
            return
        }

        let session = URLSession.shared
        print(url)

        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.mimeType == "application/json",
                (200...299).contains(response.statusCode) else {
                    onCompletion(.failure(.error(nil)))
                    return
            }
            guard let data = data else {
                onCompletion(.failure(.error(nil)))
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

    private func buildRequestURL(using parameters: WeatherRequestParameters) -> URL? {
        var urlComponents = getURLComponents()
        var queryItems = parameters.asURLQueryItems()
        queryItems.append(URLQueryItem(name: "appid", value: WeatherAPI.key))
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
