//
//  ForecastTableViewController.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/14/21.
//

import UIKit

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

class ForecastTableViewController: UITableViewController, ForecastPresenterDelegate {
    
    // MARK: Properties
    
    let forecastPresenter = ForecastPresenter()
    var forecast: WeatherModel?
    let dateManager = DateManager()
    
    var determinationArray: [[Int]]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let forecast = forecast else { return nil }
        let arrOfDates = forecast.forecastDetails.map {
            dateFormatter.date(from: $0.forecastTimeStamp)
        }
        let arrOfDays = arrOfDates.map { (day: Date?) -> Int in
            guard let day = day else { return 0 }
            return Calendar.current.component(.day, from: day)
        }
        let valueToReturn = Set(arrOfDays).sorted().map { (value) in
            arrOfDays.filter {
                $0 == value
            }
        }
        return valueToReturn
    }
    
    var sectionTitles: [String]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let forecast = forecast else { return nil }
        let arrOfDates = forecast.forecastDetails.map {
            dateFormatter.date(from: $0.forecastTimeStamp)
        }
        let arrOfWeekDaysInt = arrOfDates.map {
            Calendar.current.component(.weekday, from: $0!)
        }
        let arrOfWeekDaysString = arrOfWeekDaysInt.map {
            dateFormatter.weekdaySymbols[$0 - 1]
        }
        return arrOfWeekDaysString.unique()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        forecastPresenter.delegate = self
        forecastPresenter.getForecastData()
        let nib = UINib(nibName: "ForecastTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.ForecastTableViewCellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return determinationArray?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return determinationArray?[section].count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ForecastTableViewCellIdentifier, for: indexPath) as! ForecastTableViewCell
        if let forecast = forecast {
            cell.conditionsSymbolImageView.image = UIImage(systemName: forecast.currentConditionsSymbol)
            cell.forecastTimeLabel.text = "HH:mm"
            cell.conditionsLabel.text = forecast.currentConditions
            cell.temperatureLabel.text = forecast.currentTemperature
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionTitles = sectionTitles else { return "No data" }
        return section == 0 ? "Today" : sectionTitles[section]
    }
    
    // MARK: ForecastPresenterDelegate methods
    
    func presentForecast(forecast: WeatherModel) {
        self.forecast = forecast
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

}
