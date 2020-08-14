//
//  ReverseGeocodingAPI.swift
//  WeatherApp
//
//  Created by dludlow7 on 01/08/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class ReverseGeocodingAPI: API {
    var scheme: String = "https"
    var host: String = "eu1.locationiq.com"
    var path: String = "/v1/reverse.php"
    static let key = "5b0809a5d38d91"

    func getURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        return components
    }
}
