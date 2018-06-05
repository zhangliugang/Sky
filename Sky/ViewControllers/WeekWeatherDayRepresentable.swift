//
//  WeekWeatherDayRepresentable.swift
//  Sky
//
//  Created by 张留岗 on 6/5/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

protocol WeekWeatherDayRepresentable {
	var week: String { get }
	var date: String { get }
	var temperature: String { get }
	var weatherIcon: UIImage? { get }
	var humidity: String { get }
}
