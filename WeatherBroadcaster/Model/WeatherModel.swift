//
//  WeatherModel.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import Foundation

struct WeatherModel: Codable {
    
    let city: String
    let country: String
    let forecastDetails: [ForecastDetails]
    
    // MARK: - Current weather report computed properties
    
    var currentConditionsSymbol: Int {
        guard let value = forecastDetails.first?.weather.first?.id else { return 0 }
        return Int(value)
    }
    
    var currentTemperature: String {
        guard let value = forecastDetails.first?.main.temperature else { return "No data" }
        return String(Int(value.rounded()))
    }
    
    var currentConditions: String {
        guard let value = forecastDetails.first?.weather.first?.description else { return "No data" }
        return value
    }
    
    var currentProbabilityOfPrecipitation: String {
        guard let value = forecastDetails.first?.probabilityOfPrecipitation else { return "No data" }
        return String(Int(value.rounded()))
    }
    
    var currentRainVolume: Double? {
        forecastDetails.first?.rain?.rainVolume
    }
    
    var currentPressure: String {
        guard let value = forecastDetails.first?.main.pressure else { return "No data" }
        return String(value)
    }
    
    var currentWindSpeed: String {
        guard let value = forecastDetails.first?.wind.speed else { return "No data" }
        return String(Int(value.rounded()))
    }
    
    var currentWindDirection: String {
        guard let value = forecastDetails.first?.wind.directionInDegrees else { return "No data" }
        
        switch value {
        case 0...23, 337...360:
            return "N"
        case 24...68:
            return "NE"
        case 69...113:
            return "E"
        case 114...158:
            return "SE"
        case 159...203:
            return "S"
        case 204...248:
            return "SW"
        case 249...293:
            return "W"
        case 294...336:
            return "NW"
        default:
            return "No data"
        }
        
    }
    
    var forecastTimeStamp: String {
        forecastDetails.first?.forecastTimeStamp ?? "No data"
    }
    
}

// MARK: - Extensions

// Used to interpret Int as UIImage system name

extension Int {
    func symbolName() -> String {
        switch self {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...521:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 800...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
