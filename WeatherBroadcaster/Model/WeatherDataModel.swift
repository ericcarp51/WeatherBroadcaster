//
//  WeatherDataModel.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import Foundation

struct WeatherDataModel: Codable {
    let location: LocationDetails
    let forecastDetails: [ForecastDetails]
    
    private enum CodingKeys: String, CodingKey {
        case location = "city"
        case forecastDetails = "list"
    }
}

struct LocationDetails: Codable {
    let city: String
    let country: String
    
    private enum CodingKeys: String, CodingKey {
        case city = "name"
        case country
    }
}

struct ForecastDetails: Codable {
    let main: MainDetails
    let weather: [WeatherDetails]
    let wind: WindDetails
    let probabilityOfPrecipitation: Double
    let rain: RainDetails?
    let forecastTimeStamp: String
    
    private enum CodingKeys: String, CodingKey {
        case main
        case weather
        case wind
        case probabilityOfPrecipitation = "pop"
        case rain
        case forecastTimeStamp = "dt_txt"
    }
}

struct MainDetails: Codable {
    let temperature: Double
    let pressure: Int
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case pressure
    }
}

struct WeatherDetails: Codable {
    let id: Int
    let description: String
}

struct WindDetails: Codable {
    let speed: Double
    let directionInDegrees: Int
    
    private enum CodingKeys: String, CodingKey {
        case speed
        case directionInDegrees = "deg"
    }
}

struct RainDetails: Codable {
    let rainVolume: Double
    
    private enum CodingKeys: String, CodingKey {
        case rainVolume = "3h"
    }
}
