//
//  Defaults.swift
//  WeatherApp
//
//  Created by dludlow7 on 31/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct Defaults {
    private var userDefaults = UserDefaults.standard

    init(using userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func set<T: Codable>(_ value: T, forKey key: DefaultsKeys) {
        guard let data = try? JSONEncoder().encode(value) else {
            fatalError("Could not encode value!")
        }
        userDefaults.set(data, forKey: key.rawValue)
    }

    func get<T: Codable>(_ key: DefaultsKeys) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue),
              let value = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return value
    }

    func hasKey(_ key: DefaultsKeys) -> Bool {
        return userDefaults.object(forKey: key.rawValue) != nil
    }
}

enum DefaultsKeys: String {
    case savedLocations = "KEY_savedLocations"
    case hasSeenIntro = "KEY_hasSeenIntro"
}
