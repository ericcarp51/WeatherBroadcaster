//
//  ForecastTableViewCell.swift
//  WeatherBroadcaster
//
//  Created by Eric Carp on 5/16/21.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var conditionsSymbolImageView: UIImageView!
    @IBOutlet weak var forecastTimeLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
