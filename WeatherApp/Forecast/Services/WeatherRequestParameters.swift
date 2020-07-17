//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by dludlow7 on 21/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct WeatherRequestParameters {
    var latitude: String?
    var longitude: String?
    var units: String?

    func asURLQueryItems() -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "lat", value: latitude))
        queryItems.append(URLQueryItem(name: "lon", value: longitude))
        queryItems.append(URLQueryItem(name: "units", value: units))
        return queryItems
    }
}
