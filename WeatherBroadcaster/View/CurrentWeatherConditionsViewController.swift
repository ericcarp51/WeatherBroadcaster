//
//  CurrentWeatherConditionsViewController.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import UIKit
import Network

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
    
    var forecastPresenter = ForecastPresenter()
    var forecast: WeatherModel?
    var networkCheck = NetworkCheck.sharedInstance()
    
    // MARK: - Lifecycle points
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Today"
        if networkCheck.currentStatus == .satisfied {
            forecastPresenter = ForecastPresenter()
            //Set the forecast presenter's delegate as CurrentWeatherConditionsViewController
            forecastPresenter.delegate = self
        } else {
            presentAlert()
        }
    }
    
    // MARK: - Forecast presenter delegate methods
    
    func presentForecast(forecast: WeatherModel) {
        self.forecast = forecast
        updateUI()
    }
    
    // MARK: - Actions
    
    // Used to share the received weather information as a string
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let forecast = forecast else { return }
        let textToShare = "Check this out! I'm in \(forecast.city)! And it's \(forecast.currentTemperature)℃ here!"
        let activityController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    // Used to update the user's interface with the received information
    
    func updateUI() {
        guard let forecast = forecast else { return }
        DispatchQueue.main.async { [weak self] in
            self?.currentConditionsSymbolImageView.image = UIImage(systemName: forecast.currentConditionsSymbol.symbolName())
            self?.cityAndCountryLabel.text = "\(forecast.city), \(forecast.country)"
            self?.temperatureAndConditionsLabel.text = "\(forecast.currentTemperature)℃ | \(forecast.currentConditions.capitalized)"
            self?.currentProbabilityOfPrecipitationLabel.text = "\(forecast.currentProbabilityOfPrecipitation)%"
            self?.currentRainVolumeLabel.text = forecast.currentRainVolume != nil ? "\(forecast.currentRainVolume!) mm" : "No rain"
            self?.currentPressureLabel.text = "\(forecast.currentPressure) hPa"
            self?.currentWindSpeedLabel.text = "\(forecast.currentWindSpeed) km/h"
            self?.currentWindDirectionLabel.text = forecast.currentWindDirection
        }
    }
    
    // Used to show an alert if the Internet connection is unavailable
    
    func presentAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "This App Requires Internet Connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alert) in }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
