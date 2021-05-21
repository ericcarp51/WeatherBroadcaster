//
//  ForecastByDate.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/19/21.
//

import Foundation

struct ForecastByDate {
    let date: Date
    let forecasts: [ForecastByTime]
}

struct ForecastByTime {
    let symbol: Int
    let time: Date
    let conditions: String
    let temperature: Int
}
