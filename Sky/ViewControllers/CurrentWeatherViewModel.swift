//
//  CurrentWeatherViewModel.swift
//  Sky
//
//  Created by 张留岗 on 6/1/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {

	static let empty = CurrentWeatherViewModel(weather: WeatherData.empty)
	static let inlid = CurrentWeatherViewModel(weather: .invalid)
	
	var isEmpty: Bool {
		return self.weather == WeatherData.empty
	}
	
	var isInvalid: Bool {
		return self.weather == .invalid
	}
	
	var weather: WeatherData!

	var temperature: String {
        switch UserDefaults.temperatureMode() {
        case .celsius:
            return String(format: "%.1f °C", weather.currently.temperature.toCelsius())
        case .fahrenheit:
            return String(format: "%.1f °F", weather.currently.temperature)
        }
		
	}
	
	var humidity: String {
		return String(format: "%.1f %%", weather.currently.humidity * 100)
	}
	
	var summary: String {
		return weather.currently.summary
	}
	
	var date: String {
		let formatter = DateFormatter()
		formatter.dateFormat = UserDefaults.dateMode().format

		return formatter.string(from: weather.currently.time)
	}
	
	var weatherIcon: UIImage {
		return UIImage.weatherIcon(of: weather.currently.icon)!
	}
}

extension UIImage {
	class func weatherIcon(of name: String) -> UIImage? {
		switch name {
		case "clear-day":
			return UIImage(named: "clear-day")
		case "clear-night":
			return UIImage(named: "clear-night")
		case "rain":
			return UIImage(named: "rain")
		case "snow":
			return UIImage(named: "snow")
		case "sleet":
			return UIImage(named: "sleet")
		case "wind":
			return UIImage(named: "wind")
		case "cloudy":
			return UIImage(named: "cloudy")
		case "partly-cloudy-day":
			return UIImage(named: "partly-cloudy-day")
		case "partly-cloudy-night":
			return UIImage(named: "partly-cloudy-night")
		default:
			return UIImage(named: "clear-day")
		}
	}
}
