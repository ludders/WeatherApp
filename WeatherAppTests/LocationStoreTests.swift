//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by dludlow7 on 24/04/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherApp

class LocationStoreTests: XCTestCase {
    func testSortedLocationsInExpectedOrder() {
        let unsortedLocations: [Location] = [
            Location(name: "Saved 2",
                     coordinates: CLLocationCoordinate2D(latitude: 6, longitude: 6),
                     dateCreated: "1/2/2020".asDate!,
                     saved: true),
            Location(name: "Not Saved 2",
                     coordinates: CLLocationCoordinate2D(latitude: 2, longitude: 2),
                     dateCreated: "1/2/2020".asDate!,
                     saved: false),
            Location(name: "Saved 1",
                     coordinates: CLLocationCoordinate2D(latitude: 5, longitude: 5),
                     dateCreated: "1/1/2020".asDate!,
                     saved: true),
            Location(name: "Not Saved 1",
                     coordinates: CLLocationCoordinate2D(latitude: 1, longitude: 1),
                     dateCreated: "1/1/2020".asDate!,
                     saved: false),
            Location(name: "Not Saved 3",
                     coordinates: CLLocationCoordinate2D(latitude: 3, longitude: 3),
                     dateCreated: "1/3/2020".asDate!,
                     saved: false)
        ]

        let expectedLocations: [Location] = [
            Location(name: "Not Saved 1",
                     coordinates: CLLocationCoordinate2D(latitude: 1, longitude: 1),
                     dateCreated: "1/1/2020".asDate!,
                     saved: false),
            Location(name: "Not Saved 2",
                     coordinates: CLLocationCoordinate2D(latitude: 2, longitude: 2),
                     dateCreated: "1/2/2020".asDate!,
                     saved: false),
            Location(name: "Not Saved 3",
                     coordinates: CLLocationCoordinate2D(latitude: 3, longitude: 3),
                     dateCreated: "1/3/2020".asDate!,
                     saved: false),
            Location(name: "Saved 1",
                     coordinates: CLLocationCoordinate2D(latitude: 5, longitude: 5),
                     dateCreated: "1/1/2020".asDate!,
                     saved: true),
            Location(name: "Saved 2",
                     coordinates: CLLocationCoordinate2D(latitude: 6, longitude: 6),
                     dateCreated: "1/2/2020".asDate!,
                     saved: true)
        ]

        let sortedLocations = LocationStore(locations: unsortedLocations, defaults: Defaults()).sortedLocations
        XCTAssertEqual(sortedLocations, expectedLocations)
    }
}
