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
	
	struct CurrentWeather: Codable {
		let time: Date
		let summary: String
		let icon: String
		let temperature: Double
		let humidity: Double
	}
}
