//
//  TableViewDataSourceManager.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/18/21.
//

import Foundation

protocol TableViewDataSourceManagerDelegate {
}

struct TableViewDataSourceManager {
    
    func getArrayOfDays(forecast: WeatherModel) -> [DayForecast] {
        var result = [Forecast]()
        for item in forecast.forecastDetails {
            result.append(Forecast(symbol: Int(item.weather.first?.id ?? 0) , time: item.forecastTimeStamp.transformToDate(), conditions: item.weather.first?.description ?? "No data", temperature: Int(item.main.temperature)))
        }
        
        let timeZoneDifference = TimeZone.current.secondsFromGMT()
        
        let grouped = Dictionary(grouping: result) {
            Calendar.current.startOfDay(for: $0.time - TimeInterval(timeZoneDifference))
        }
        
        let groupedAndSorted = grouped.sorted(by: { $0.0 < $1.0 })
        
        return groupedAndSorted.map { DayForecast(date: $0.key, forecasts: $0.value) }
    }
    
}

extension String {
    func transformToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self) ?? Date()
    }
}
