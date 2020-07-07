//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by dludlow7 on 18/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct WeatherAPI: API {
    var scheme: String = "https"
    var domainName: String = "api.openweathermap.org"
    var path: String = "/data/2.5/onecall"
    static let key = "e98f45a3667d7ec23c10d818ae358583"

    func getURLComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = domainName
        urlComponents.path = path

        return urlComponents
    }
}
