//
//  SuggestionsRequestParameters.swift
//  WeatherApp
//
//  Created by dludlow7 on 09/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct SuggestionsRequestParameters {
    var searchString: String?

    func asURLQueryItems() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: searchString),
            URLQueryItem(name: "addressdetails", value: "1"),
            URLQueryItem(name: "format", value: "json")
        ]
    }
}
