//
//  ForecastTableViewController.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import UIKit

class ForecastTableViewController: UITableViewController, ForecastPresenterDelegate {
    
    // MARK: - Properties
    
    let forecastPresenter = ForecastPresenter()
    var forecast: WeatherModel?
    let tableViewSourceManager = TableViewDataSourceManager()
    let dateFormatter = DateFormatter()
    
    // MARK: - Lifecycle points
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastPresenter.delegate = self
        forecastPresenter.forecastService.sendRequest()
        let nib = UINib(nibName: "ForecastTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.ForecastTableViewCellIdentifier)
    }

    // MARK: - Table view data source methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let forecast = forecast else { return 0 }
        return tableViewSourceManager.getArrayOfDays(forecast: forecast).count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forecast = forecast else { return 0 }
        return tableViewSourceManager.getArrayOfDays(forecast: forecast)[section].forecasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ForecastTableViewCellIdentifier, for: indexPath) as! ForecastTableViewCell
        if let forecast = forecast {
            let item = tableViewSourceManager.getArrayOfDays(forecast: forecast)[indexPath.section].forecasts[indexPath.row]
            cell.conditionsSymbolImageView.image = UIImage(systemName: item.symbol.symbolName())
            cell.forecastTimeLabel.text = "\(item.time)"
            cell.conditionsLabel.text = item.conditions.capitalized
            cell.temperatureLabel.text = "\(item.temperature)º"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let forecast = forecast else { return "No data" }
        let item = tableViewSourceManager.getArrayOfDays(forecast: forecast)
        let weekDayInt = Calendar.current.component(.weekday, from: item[section].date)
        let weekDayString = dateFormatter.weekdaySymbols[weekDayInt - 1]
        return weekDayString
    }
    
    // MARK: - ForecastPresenterDelegate methods
    
    func presentForecast(forecast: WeatherModel) {
        self.forecast = forecast
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.title = forecast.city.capitalized
        }
    }

}
