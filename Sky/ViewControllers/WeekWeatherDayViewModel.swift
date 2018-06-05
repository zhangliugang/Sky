//
//  WeekWeatherDayViewModel.swift
//  Sky
//
//  Created by 张留岗 on 6/5/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

struct WeekWeatherDayViewModel: WeekWeatherDayRepresentable {
	let weatherData: ForecastData
	
	private let dateFormatter = DateFormatter()
	
	var week: String {
		dateFormatter.dateFormat = "EEEE"
		return dateFormatter.string(from: weatherData.time)
	}
	
	var date: String {
		dateFormatter.dateFormat = "MMMM d"
		return dateFormatter.string(from: weatherData.time)
	}
	
	var temperature: String {
		let min = format(temperature: weatherData.temperatureLow)
		let max = format(temperature: weatherData.temperatureHigh)
		
		return "\(min) - \(max)"
	}
	
	var weatherIcon: UIImage? {
		return UIImage.weatherIcon(of: weatherData.icon)
	}
	
	var humidity: String {
		return String(format: "%.f %%", weatherData.humidity * 100)
	}
	
	/// Helpers
	private func format(temperature: Double) -> String {
		switch UserDefaults.temperatureMode() {
		case .celsius:
			return String(format: "%.0f °C", temperature.toCelsius())
		case .fahrenheit:
			return String(format: "%.0f °F", temperature)
		}
	}
}
