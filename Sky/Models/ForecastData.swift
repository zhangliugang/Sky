//
//  ForecastData.swift
//  Sky
//
//  Created by August on 6/3/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

struct ForecastData: Codable {
    let time: Date
    let temperatureLow: Double
    let temperatureHigh: Double
    let icon: String
    let humidity: Double
}

extension ForecastData: Equatable {
    static func ==(lhs: ForecastData, rhs: ForecastData) -> Bool {
        return lhs.time == rhs.time &&
            lhs.temperatureLow == rhs.temperatureLow &&
            lhs.temperatureHigh == rhs.temperatureHigh &&
            lhs.icon == rhs.icon &&
            lhs.humidity == rhs.humidity
    }
}
