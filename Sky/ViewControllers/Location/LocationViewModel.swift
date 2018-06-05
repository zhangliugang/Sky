//
//  LocationViewModel.swift
//  Sky
//
//  Created by 张留岗 on 6/5/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationsViewModel {
	let location: CLLocation?
	let locationText: String?
}

extension LocationsViewModel: LocationRepresentable {
	var labelText: String {
		if let locationText = locationText {
			return locationText
		}
		else if let location = location {
			return location.toString
		}
		return "Unknown position"
	}
}

extension CLLocation {
	var toString: String {
		let latitude = String(format: "%.3f", coordinate.latitude)
		let longitude = String(format: "%.3f", coordinate.longitude)
		
		return "\(latitude), \(longitude)"
	}
}
