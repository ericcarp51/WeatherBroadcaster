//
//  CurrentWeatherConditionsViewController.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import UIKit

class CurrentWeatherConditionsViewController: UIViewController, ForecastPresenterDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var currentConditionsSymbolImageView: UIImageView!
    @IBOutlet weak var cityAndCountryLabel: UILabel!
    @IBOutlet weak var temperatureAndConditionsLabel: UILabel!
    @IBOutlet weak var currentProbabilityOfPrecipitationLabel: UILabel!
    @IBOutlet weak var currentRainVolumeLabel: UILabel!
    @IBOutlet weak var currentPressureLabel: UILabel!
    @IBOutlet weak var currentWindSpeedLabel: UILabel!
    @IBOutlet weak var currentWindDirectionLabel: UILabel!
    
    // MARK: - Properties
    
    let forecastPresenter = ForecastPresenter()
    var forecast: WeatherModel?
    
    // MARK: - Lifecycle points
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the forecast presenter's delegate as CurrentWeatherConditionsViewController
        forecastPresenter.delegate = self
    }
    
    // MARK: Forecast presenter delegate methods
    
    func presentForecast(forecast: WeatherModel) {
        self.forecast = forecast
        updateUI()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let forecast = forecast else { return }
        let textToShare = "Check this out! I'm in \(forecast.city)! And it's \(forecast.currentTemperature)℃ here!"
        let activityController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    func updateUI() {
        guard let forecast = forecast else { return }
        DispatchQueue.main.async { [weak self] in
            self?.title = "Today"
            self?.currentConditionsSymbolImageView.image = UIImage(systemName: forecast.currentConditionsSymbol)
            self?.cityAndCountryLabel.text = "\(forecast.city), \(forecast.country)"
            self?.temperatureAndConditionsLabel.text = "\(forecast.currentTemperature)℃ | \(forecast.currentConditions.capitalized)"
            self?.currentProbabilityOfPrecipitationLabel.text = "\(forecast.currentProbabilityOfPrecipitation)%"
            self?.currentRainVolumeLabel.text = forecast.currentRainVolume != nil ? "\(forecast.currentRainVolume!) mm" : "No rain"
            self?.currentPressureLabel.text = "\(forecast.currentPressure) hPa"
            self?.currentWindSpeedLabel.text = "\(forecast.currentWindSpeed) km/h"
            self?.currentWindDirectionLabel.text = forecast.currentWindDirection
        }
    }
    
}
