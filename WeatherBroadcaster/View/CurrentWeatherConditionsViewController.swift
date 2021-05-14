//
//  CurrentWeatherConditionsViewController.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import UIKit

class CurrentWeatherConditionsViewController: UIViewController, ForecastPresenterDelegate {
    
    @IBOutlet weak var cityAndCountryLabel: UILabel!
    
    let forecastPresenter = ForecastPresenter()
    
    var forecast: WeatherModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Presenter
        forecastPresenter.delegate = self
    }
    
    // MARK: Forecast presenter delegate methods
    
    func presentForecast(forecast: WeatherModel) {
        self.forecast = forecast
        updateUI()
    }
    
    @IBAction func go(_ sender: UIButton) {
        forecastPresenter.getData()
    }
    
    func updateUI() {
        guard let forecast = forecast else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.cityAndCountryLabel.text = "\(forecast.city), \(forecast.country)"
        }
    }
    
}
