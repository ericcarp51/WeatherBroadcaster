//
//  ForecastService.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/17/21.
//

import UIKit
import CoreLocation
import Network

protocol ForecastServiceDelegate {
    func getForecastData(data: WeatherModel)
    func didFail(with error: Error)
}

class ForecastService: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var delegate: ForecastServiceDelegate?
    var networkCheck = NetworkCheck.sharedInstance()
    var latitude: Double?
    var longitude: Double?
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        if networkCheck.currentStatus == .satisfied {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Class methods
    
    // Used to get a weather report using the user's current location or default location in case of an unexpected error
    
    func sendRequest() {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            let urlString = "\(Constants.baseURL)&lat=\(latitude ?? 41)&lon=\(longitude ?? 12)"
            print(urlString)
            guard let url = URL(string: urlString) else { return }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data, error == nil else { return }
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedData = try jsonDecoder.decode(WeatherDataModel.self, from: data)
                    let city = decodedData.location.city
                    let country = decodedData.location.country
                    let forecastDetails = decodedData.forecastDetails
                    let weatherModel = WeatherModel(city: city, country: country, forecastDetails: forecastDetails)
                    self?.delegate?.getForecastData(data: weatherModel)
                } catch {
                    self?.delegate?.didFail(with: error)
                }
            }
            task.resume()
        }
    }
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        sendRequest()
    }
    
}
