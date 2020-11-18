//
//  LocationRepository.swift
//  WeatherApp
//
//  Created by dludlow7 on 15/11/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class LocationRepository {
    private var cache: [Location: LocationForecast]
    private var defaults: Defaults

    public var savedLocations: [Location] {
        return cache.map { $0.key }
            .filter { $0.saved }
    }

    init(cache: [Location: LocationForecast] = [:],
         defaults: Defaults) {
        self.cache = cache
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
