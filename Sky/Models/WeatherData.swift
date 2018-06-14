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
	
	static let empty = WeatherData(
		latitude: 0,
		longitude: 0,
		currently: CurrentWeather(
			time: Date.from(string: "1970-01-01"),
			summary: "",
			icon: "",
			temperature: 0,
			humidity: 0),
		daily: WeekWeatherData(data: []))
	
	static let invalid = WeatherData(
		latitude: 0,
		longitude: 0,
		currently: CurrentWeather(
			time: Date.from(string: "1970-01-01"),
			summary: "n/a", icon: "n/a",
			temperature: -274, humidity: -1),
		daily: WeekWeatherData(data: []))
	
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

extension WeatherData: Equatable {}

extension WeatherData.WeekWeatherData: Equatable {
    static func ==(lhs: WeatherData.WeekWeatherData, rhs: WeatherData.WeekWeatherData) -> Bool {
        return lhs.data == rhs.data
    }
}

extension WeatherData.CurrentWeather: Equatable {}


extension Date {
	static func from(string: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-mm-dd"
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT+8:00")
		return dateFormatter.date(from: string)!
	}
}
