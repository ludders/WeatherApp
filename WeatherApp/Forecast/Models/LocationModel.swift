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

struct Location: Codable, Equatable, Hashable {
    let name: String
    let latitude: Double
    let longitude: Double
    var saved: Bool

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Location {
    init(name: String, coordinates: CLLocationCoordinate2D, saved: Bool = false) {
        self.init(name: name,
                  latitude: coordinates.latitude,
                  longitude: coordinates.longitude,
                  saved: saved)
    }
}
