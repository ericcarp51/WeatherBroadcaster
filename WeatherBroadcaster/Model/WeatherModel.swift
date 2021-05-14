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
}

/*
 
 let temperature: String
 let conditions: String
 let probabilityOfPrecipitation: String
 let rainVolume: String?
 let pressure: String
 let windSpeed: String
 let windDirection: String
 
 */
