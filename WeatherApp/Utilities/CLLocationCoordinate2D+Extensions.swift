//
//  CLLocationCoordinate2D.swift
//  WeatherApp
//
//  Created by dludlow7 on 05/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    public static var nullIsland: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
