//
//  Weather.swift
//  Weather app
//
//  Created by Ernest Mihasenko on 20.07.22.
//

import Foundation

struct NetworkWeatherData: Codable {
    var lat, lon: Double
    var timezone: String
    var current: Current
    var daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case current
        case daily
    }
}

// MARK: - Current
struct Current: Codable {
    var temp: Double
    var humidity: Int
    var windSpeed: Double
    var weather: [WeatherDescription]
    
    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        case windSpeed = "wind_speed"
        
        case weather
    }
}

// MARK: - Weather
struct WeatherDescription: Codable {
    var weatherDescription: Description
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
    
    var emojiStatus: String {
        switch self {
        case .brokenClouds:
            return "⛅️"
        case .clearSky:
            return "☀️"
        case .fewClouds:
            return "🌤"
        case .lightRain:
            return "🌦"
        case .moderateRain:
            return "🌧"
        case .overcastClouds:
            return "☁️"
        case .scatteredClouds:
            return "⛅️"
        }
    }
    
    var localizedStatus: String {
        switch self {
        case .brokenClouds:
            return NSLocalizedString("broken clouds", comment: "")
        case .clearSky:
            return NSLocalizedString("clear sky", comment: "")
        case .fewClouds:
            return NSLocalizedString("few clouds", comment: "")
        case .lightRain:
            return NSLocalizedString("light rain", comment: "")
        case .moderateRain:
            return NSLocalizedString("moderate rain", comment: "")
        case .overcastClouds:
            return NSLocalizedString("overcast clouds", comment: "")
        case .scatteredClouds:
            return NSLocalizedString("scattered clouds", comment: "")
        }
    }
}

struct Daily: Codable {
    var temp: Temp
    var weather: [WeatherDescription]
    var date: Int
    
    
    enum CodingKeys: String, CodingKey {
        case temp
        case weather
        case date = "dt"
    }
}

struct Temp: Codable {
    var day, min, max, night: Double
//    var eve, morn: Double
}

