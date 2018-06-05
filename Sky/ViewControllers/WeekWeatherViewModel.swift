//
//  WeakWeatherViewModel.swift
//  Sky
//
//  Created by August on 6/3/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import UIKit

struct WeekWeatherViewModel {
    let weatherData: [ForecastData]
    
    private let dateFormatter = DateFormatter()
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherData.count
    }
	
	func viewModel(for index:Int) -> WeekWeatherDayViewModel {
		return WeekWeatherDayViewModel(weatherData: weatherData[index])
	}
	
	/**
    func week(for index: Int) -> String {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(
            from: weatherData[index].time)
    }
    
    func date(for index: Int) -> String {
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(
            from: weatherData[index].time)
    }
    
    func temperature(for index: Int) -> String {
        let min = format(temperature: weatherData[index].temperatureLow)
        let max = format(temperature: weatherData[index].temperatureHigh)

        
        return "\(min) - \(max)"
    }
    
    func weatherIcon(for index: Int) -> UIImage? {
        return UIImage.weatherIcon(of: weatherData[index].icon)
    }
    
    func humidity(for index: Int) -> String {
        return String(format: "%.0f %%", weatherData[index].humidity)
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
*/
}
