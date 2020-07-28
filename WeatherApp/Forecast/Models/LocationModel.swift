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
    let name: String
    let coordinates: CLLocationCoordinate2D
    var forecast: LocationForecast? = nil
}
