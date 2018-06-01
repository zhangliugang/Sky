//
//  CurrentWeatherViewController.swift
//  Sky
//
//  Created by 张留岗 on 6/1/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import UIKit

class CurrentWeatherViewController: WeatherViewController {
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var weatherIcon: UIImageView!
	@IBOutlet weak var humiditytLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	weak var delegate: CurrentWeatherViewControllerDelegate?
	
	var viewModel: CurrentWeatherViewModel? {
		didSet {
			DispatchQueue.main.async {
				self.updateView()
			}
		}
	}
	
	@IBAction func locationButtonPressed(_ sender: UIButton) {
		delegate?.locationButtonPressed(controller: self)
	}
	
	@IBAction func settingButtonPressed(_ sender: UIButton) {
		delegate?.settingButtonPressed(controller: self)
	}
	
	func updateView () {
		activityIndicatorView.stopAnimating()
		
		if let vm = viewModel, vm.isUpdateReady {
			updateWeatherContainer(with: vm)
		} else {
			loadingFailedLabel.isHidden = false
			loadingFailedLabel.text = "Cannot load fetch weather/location data from the network."
		}
	}
	
	func updateWeatherContainer(with vm: CurrentWeatherViewModel) {
		weatherContainerView.isHidden = false
		locationLabel.text = vm.city
		temperatureLabel.text = vm.temperature
		weatherIcon.image = vm.weatherIcon
		humiditytLabel.text = vm.humidity
		summaryLabel.text = vm.summary
		dateLabel.text = vm.date
	}
}

extension Double {
	func toCelcius() -> Double {
		return (self - 32.0) / 1.8
	}
}

protocol CurrentWeatherViewControllerDelegate: class {
	func locationButtonPressed(controller: CurrentWeatherViewController)
	func settingButtonPressed(controller: CurrentWeatherViewController)
}
