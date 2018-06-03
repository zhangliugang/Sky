//
//  File.swift
//  Sky
//
//  Created by 张留岗 on 5/31/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
	let latitude: Double
	let longitude: Double
	let currently: CurrentWeather
    let daily: WeekWeatherData
	
	struct CurrentWeather: Codable {
		let time: Date
		let summary: String
		let icon: String
		let temperature: Double
		let humidity: Double
	}
    
    struct WeekWeatherData: Codable {
        let data: [ForecastData]
    }
}

extension WeatherData.WeekWeatherData: Equatable {
    static func ==(lhs: WeatherData.WeekWeatherData, rhs: WeatherData.WeekWeatherData) -> Bool {
        return lhs.data == rhs.data
    }
}
