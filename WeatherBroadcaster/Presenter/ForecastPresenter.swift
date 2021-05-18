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

class ForecastPresenter {
    
    weak var delegate: ForecastPresenterDelegate?
    
    func setViewDelegate(delegate: ForecastPresenterDelegate) {
        self.delegate = delegate
    }
    
    func getForecastData() {
        
        guard let url = URL(string: Constants.url) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let decodedData = try jsonDecoder.decode(WeatherDataModel.self, from: data)
                let city = decodedData.location.city
                let country = decodedData.location.country
                let forecastDetails = decodedData.forecastDetails
                let weatherModel = WeatherModel(city: city, country: country, forecastDetails: forecastDetails)
                print(weatherModel)
                self.delegate?.presentForecast(forecast: weatherModel)
            } catch {
                print("ERROR! \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}
