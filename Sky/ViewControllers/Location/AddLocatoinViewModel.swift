//
//  AddLocatoinViewModel.swift
//  Sky
//
//  Created by 张留岗 on 6/8/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import CoreLocation

class AddLocationViewModel {
	var queryingStatusDidChange: ((Bool) -> Void)?
	var locationDidChange: (([Location]) -> Void)?
	
	var queryText = "" {
		didSet {
			geocode(address: queryText)
		}
	}
	private lazy var geocoder = CLGeocoder()
	
	private var isQuerying = false {
		didSet {
			queryingStatusDidChange?(isQuerying)
		}
	}
	private var locations: [Location] = [] {
		didSet {
			locationDidChange?(locations)
		}
	}
	
	var numberOfLocations: Int {
		return locations.count
	}
	
	var hasLocationResult: Bool {
		return numberOfLocations > 0
	}
	
	func locationViewModel(at index:Int) -> LocationRepresentable? {
		guard let location = location(at: index) else {
			return nil
		}
		return LocationsViewModel(location: location.location, locationText: location.name)
	}
	
	func location(at index:Int) -> Location? {
		guard index < numberOfLocations else {
			return nil
		}
		
		return locations[index]
	}
	
	private func geocode(address: String?) {
		guard let address = address, !address.isEmpty else {
			locations = []
			return
		}
		
		isQuerying = true
		
		geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
			self?.processResponse(with: placemarks, error: error)
		}
	}
	
	private func processResponse(with placeMarks: [CLPlacemark]?, error: Error?) {
		isQuerying = false
		var locs: [Location] = []
		
		if let error = error {
			print("Cannot handle Geocode Address! \(error)")
		}else if let placemarks = placeMarks {
			locs = placemarks.compactMap {
				guard let name = $0.name else { return nil }
				guard let locatoin = $0.location else { return nil }
				
				return Location(name: name, latitude: locatoin.coordinate.latitude, longitude: locatoin.coordinate.longitude)
			}
			
			self.locations = locs
		}
	}
}
