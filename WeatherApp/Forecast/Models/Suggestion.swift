//
//  Suggestion.swift
//  WeatherApp
//
//  Created by dludlow7 on 09/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import CoreLocation
import Foundation

struct Suggestion {
    let displayName: String
    let coordinates: CLLocationCoordinate2D

    var shortName: String {
        return String(displayName.split(separator: ",")[0])
    }
}
