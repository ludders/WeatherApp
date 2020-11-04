//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by dludlow7 on 20/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct WeatherResponse: Codable {
    let lat, lon: Double?
    let timezone: String?
    let timezoneOffset: Int?
    let hourly: [HourlyWeatherResponse]?
    let daily: [DailyWeatherResponse]?

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case hourly, daily
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

// MARK: - Daily
struct DailyWeatherResponse: Codable {
    let dt: Date
    let sunrise, sunset: Date?
    let temp: Temp?
    let feelsLike: FeelsLike?
    let pressure, humidity: Int?
    let dewPoint, windSpeed: Double?
    let windDeg: Int?
    let weather: [Weather]?
    let clouds: Int?
    let uvi, rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, uvi, rain
    }
}


// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double?
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double?
    let eve, morn: Double?
}

// MARK: - Hourly
struct HourlyWeatherResponse: Codable {
    let dt: Date?
    let temp, feelsLike: Double?
    let pressure, humidity: Int?
    let dewPoint: Double?
    let clouds: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let weather: [Weather]?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}
