//
//  LocationStore.swift
//  WeatherApp
//
//  Created by dludlow7 on 15/11/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//
import Foundation

class LocationStore {
    private var locationSet: NSMutableOrderedSet
    private var cache: [Location: LocationForecast] = [:]
    private var defaults: Defaults

    public var locations: [Location] {
        return locationSet.map { $0 as! Location }
    }

    public var savedLocations: [Location] {
        return locationSet.map { $0 as! Location }
            .filter { $0.saved }
    }

    init(locations: [Location],
         defaults: Defaults) {
        self.locationSet = NSMutableOrderedSet(array: locations)
        self.defaults = defaults
    }

    public func add(_ location: Location) {
        locationSet.add(location)
    }

    public func save(_ location: Location) {
        if let original = locationSet.map({ $0 as! Location }).first(where: { $0 == location }) {
            locationSet.replaceObject(at: locationSet.index(of: original), with: location)
            defaults.set(savedLocations, forKey: .savedLocations)
        }
    }

    public func getCachedForecast(for location: Location) -> LocationForecast? {
        return cache[location]
    }

    public func updateCachedForecast(for location: Location, with newForecast: LocationForecast) {
        if let index = cache.firstIndex(where: { $0.key == location }) {
            cache.remove(at: index)
        }
        cache[location] = newForecast
    }
}
