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

    private var sortClosure: ((Location, Location) -> Bool) = { (location1, location2) in
        // Unsaved appear before Saved, then sort by creation date.
        if location1.saved == location2.saved {
            return location1.dateCreated < location2.dateCreated
        } else {
            return location1.saved == false && location2.saved == true
        }
    }

    public var sortedLocations: [Location] {
        return locationSet.map { $0 as! Location }
            .sorted(by: self.sortClosure)
    }

    public var savedLocations: [Location] {
        return cache.map { $0.key }
            .filter { $0.saved }
    }

    init(locations: [Location],
         defaults: Defaults) {
        self.locationSet = NSMutableOrderedSet(array: locations)
        self.defaults = defaults
    }

    public func getCachedForecast(for location: Location) -> LocationForecast? {
        return cache[location]
    }

    func updateCache(using model: LocationModel) {
        if let index = cache.firstIndex(where: { $0.key == model.location }) {
            cache.remove(at: index)
        }
        cache[model.location] = model.forecast
        //TODO: This is saving to UserDefaults all the time regardless of whether or not the saved locations have changed.
        //Find a neater way (i.e. only doing this when necessary)
        defaults.set(savedLocations, forKey: .savedLocations)
    }
}
