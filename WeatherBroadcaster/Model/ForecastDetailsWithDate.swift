//
//  ForecastDetailsWithDate.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/19/21.
//

import Foundation

struct DayForecast {
    let date: Date
    let forecasts: [Forecast]
}

struct Forecast {
    let symbol: Int
    let time: Date
    let conditions: String
    let temperature: Int
}
