//
//  TableViewDataSourceManager.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/18/21.
//

import Foundation

struct TableViewDataSourceManager {
    
    // MARK: - Class methods
    
    // Function to determine an array which is used as data source for the table view in ForecastTableViewController
    
    func getArrayOfDays(forecast: WeatherModel) -> [ForecastByDate] {
        var result = [ForecastByTime]()
        for item in forecast.forecastDetails {
            result.append(ForecastByTime(symbol: Int(item.weather.first?.id ?? 0) , time: item.forecastTimeStamp.transformToDate(), conditions: item.weather.first?.description ?? "No data", temperature: Int(item.main.temperature)))
        }
        let timeZoneDifference = TimeZone.current.secondsFromGMT()
        let grouped = Dictionary(grouping: result) {
            Calendar.current.startOfDay(for: $0.time - TimeInterval(timeZoneDifference))
        }
        let groupedAndSorted = grouped.sorted(by: { $0.0 < $1.0 })
        return groupedAndSorted.map { ForecastByDate(date: $0.key, forecasts: $0.value) }
    }
}

// MARK: - Extensions

// Used to transform String type of particular format into Date type

extension String {
    func transformToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        return dateFormatter.date(from: self) ?? Date()
    }
}

// Used to transform Date type into String time representation

extension Date {
    func getTimeOnly() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.timeFormate
        return dateFormatter.string(from: self)
    }
}
