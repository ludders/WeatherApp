//
//  Defaults.swift
//  WeatherApp
//
//  Created by dludlow7 on 31/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class Defaults {
    static var userDefaults = UserDefaults.standard
    private init() { }

    static func set<T>(_ value: T, forKey key: DefaultsKeys) where T: Codable {
        guard let data = try? JSONEncoder().encode(value) else {
            fatalError("Could not encode value!")
        }
        userDefaults.set(data, forKey: key.rawValue)
    }

    static func get<T>(_ type: T.Type, forKey key: DefaultsKeys) -> T? where T: Codable {
        guard let data = userDefaults.data(forKey: key.rawValue),
            let value = try? JSONDecoder().decode(type, from: data) else { return nil }
        return value
    }
}

enum DefaultsKeys: String {
    case savedLocations = "KEY_savedLocations"
    case hasSeenIntro = "KEY_hasSeenIntro"
}
