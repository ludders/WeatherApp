//
//  API.swift
//  WeatherApp
//
//  Created by dludlow7 on 18/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

protocol API {
    var scheme: String { get } //e.g. "https"
    var host: String { get } //e.g. "google.com"
    var path: String { get } //e.g. "/v2/search.php"
    func getURLComponents() -> URLComponents
}

extension API {
    func getURLComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        return urlComponents
    }
}
