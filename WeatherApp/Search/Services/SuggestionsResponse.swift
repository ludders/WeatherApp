//
//  SuggestionsResponse.swift
//  WeatherApp
//
//  Created by dludlow7 on 07/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

typealias SuggestionsResponse = [SuggestionResult]

struct SuggestionResult: Codable {
    let id: String
    let lat: String
    let lon: String
    let displayName: String
    let address: Address

    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case displayName = "display_name"
        case lat, lon, address
    }
}

struct Address: Codable {
    let houseNumber: String?
    let road: String?
    let neighbourhood: String?
    let hamlet: String?
    let suburb: String?
    let village: String?
    let town: String?
    let cityDistrict: String?
    let city: String?
    let region: String?
    let county: String?
    let stateDistrict: String?
    let state: String?
    let stateCode: String?
    let postcode: String?
    let country: String?
    let countryCode: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case houseNumber = "house_number"
        case cityDistrict = "city_district"
        case stateDistrict = "state_district"
        case countryCode = "country_code"
        case stateCode = "state_code"
        case road, neighbourhood, hamlet, suburb, village, town, city, region, county, state, postcode, country, name
    }
}
