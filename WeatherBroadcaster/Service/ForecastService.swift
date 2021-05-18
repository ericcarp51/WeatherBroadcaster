//
//  ForecastService.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/17/21.
//

import Foundation
import CoreLocation

class ForecastService: NSObject, CLLocationManagerDelegate {
    
    let baseURLString = Constants.url
    
    let locationManager = CLLocationManager()
    
}
