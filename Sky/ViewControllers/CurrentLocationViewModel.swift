//
//  CurrentLocationViewModel.swift
//  Sky
//
//  Created by 张留岗 on 6/8/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
	var location: Location
	
	var city: String {
		return location.name
	}
	
	static let empty = CurrentLocationViewModel(location: Location.empty)
	
	var isEmpty: Bool {
		return self.location == Location.empty
	}
}
