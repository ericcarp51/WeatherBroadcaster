//
//  ForecastTableViewController.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import UIKit

class ForecastTableViewController: UITableViewController, ForecastPresenterDelegate {
    
    // MARK: Properties
    
    let forecastPresenter = ForecastPresenter()
    var forecast: WeatherModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        forecastPresenter.delegate = self
        let nib = UINib(nibName: "ForecastTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.ForecastTableViewCellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Today"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ForecastTableViewCellIdentifier, for: indexPath) as! ForecastTableViewCell
        cell.conditionsSymbolImageView.image = UIImage(systemName: "wind")
        cell.forecastTimeLabel.text = "21:00"
        cell.conditionsLabel.text = "The best weather ever!"
        cell.temperatureLabel.text = "35º"
        return cell
    }
    
    // MARK: ForecastPresenterDelegate methods
    
    func presentForecast(forecast: WeatherModel) {
        self.forecast = forecast
    }

}
