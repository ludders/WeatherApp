//
//  Location.swift
//  WeatherApp
//
//  Created by dludlow7 on 19/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import CoreLocation
import Foundation

struct LocationModel {
    let location: Location
    var forecast: LocationForecast? = nil
}

struct Location: Codable {
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Location {
    init(name: String, coordinates: CLLocationCoordinate2D) {
        self.init(name: name,
                  latitude: coordinates.latitude,
                  longitude: coordinates.longitude)
    }
}
