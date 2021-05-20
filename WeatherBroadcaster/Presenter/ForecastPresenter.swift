//
//  ForecastPresenter.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import UIKit

protocol ForecastPresenterDelegate: AnyObject {
    func presentForecast(forecast: WeatherModel)
}

class ForecastPresenter: ForecastServiceDelegate {
    
    weak var delegate: ForecastPresenterDelegate?
    
    let forecastService = ForecastService()
    
    init() {
        forecastService.delegate = self
    }
    
    // MARK: ForecastServiceDelegate required methods
    
    func getForecastData(data: WeatherModel) {
        delegate?.presentForecast(forecast: data)
    }
    
    func didFail(with error: Error) {
        print(error.localizedDescription)
    }
    
}
