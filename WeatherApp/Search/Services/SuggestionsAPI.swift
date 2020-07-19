//
//  AutocompleteAPI.swift
//  WeatherApp
//
//  Created by dludlow7 on 07/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

typealias SuggestionsResponseCompletion = Result<SuggestionsResponse, NetworkingError>

class SuggestionsAPI: API {
    var scheme: String = "https"
    var host: String = "eu1.locationiq.com"
    var path: String = "/v1/search.php"
    static let key = "5b0809a5d38d91"

//    GET https://eu1.locationiq.com/v1/search.php?key=5b0809a5d38d91&addressdetails=1&format=json&q=London

    func getURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        return components
    }

    func getSuggestionsResponse(for searchString: String, completion: @escaping (SuggestionsResponseCompletion) -> ()) {
        let parameters = SuggestionsRequestParameters(searchString: searchString)
        guard let url = buildRequestURL(using: parameters) else {
            completion(.failure(.error(nil)))
            return
        }
        print("REQUEST: \n\(url)\n")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.mimeType == "application/json" else {
                completion(.failure(.error(nil)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.error(httpResponse.statusCode)))
                return
            }

            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print("RESPONSE SUCCESS: \n\(json)\n")
                }
                let decoder = JSONDecoder()
                let suggestionsResponse: SuggestionsResponse
                do {
                    suggestionsResponse = try decoder.decode(SuggestionsResponse.self, from: data)
                    completion(.success(suggestionsResponse))
                } catch let error {
                    print(data)
                    print(error)
                }

            } else {
                completion(.failure(.error(nil)))
            }
        }

        dataTask.resume()
    }

    private func buildRequestURL(using parameters: SuggestionsRequestParameters) -> URL? {
        var urlComponents = getURLComponents()
        var queryItems = parameters.asURLQueryItems()
        queryItems.append(URLQueryItem(name: "key", value: SuggestionsAPI.key))
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
