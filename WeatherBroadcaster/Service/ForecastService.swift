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

class ForecastService: NSObject, CLLocationManagerDelegate, NetworkCheckObserver {
    
    let locationManager = CLLocationManager()
    var delegate: ForecastServiceDelegate?
    var networkCheck = NetworkCheck.sharedInstance()
    var latitude: Double?
    var longitude: Double?
    
    override init() {
        super.init()
        if networkCheck.currentStatus == .satisfied {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        networkCheck.addObserver(observer: self)
    }
    
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
                    print(weatherModel)
                    self?.delegate?.getForecastData(data: weatherModel)
                } catch {
                    self?.delegate?.didFail(with: error)
                }
            }
            task.resume()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        sendRequest()
    }
    
    // MARK: NetworkCheckObserver methods
    
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            //Do something
        } else if status == .unsatisfied {
            //Show no network alert
        }
    }
}
