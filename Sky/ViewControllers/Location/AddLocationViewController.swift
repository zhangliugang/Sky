//
//  AddLocationViewController.swift
//  Sky
//
//  Created by 张留岗 on 6/6/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UITableViewController {
	
	weak var delegate: AddLocationViewControllerDelegate?
	@IBOutlet weak var searchBar: UISearchBar!
	private var locations: [Location] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Add a location"
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		searchBar.becomeFirstResponder()
	}

	private func geocode(address: String?) {
		guard let address = address else {
			locations = []
			tableView.reloadData()
			
			return
		}
		
		CLGeocoder().geocodeAddressString(address) {
			[weak self] (placemarks, error) in
			DispatchQueue.main.async {
				self?.processResponse(with: placemarks, error: error)
			}
		}
	}
	
	private func processResponse(with placemarks: [CLPlacemark]?,
								 error: Error?) {
		if let error = error {
			print("Cannot handle Geocode Address! \(error)")
		}
		else if let results = placemarks {
			locations = results.compactMap {
				result -> Location? in
				guard let name = result.name else { return nil }
				guard let location = result.location else { return nil }
				
				return Location(name: name,
								latitude: location.coordinate.latitude,
								longitude: location.coordinate.longitude)
			}
			
			tableView.reloadData()
		}
	}
}

extension AddLocationViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return locations.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: LocationTableViewCell.reuseIdentifier,
			for: indexPath) as? LocationTableViewCell else {
				fatalError("Unexpected table view cell")
		}
		
		let location = locations[indexPath.row]
		let vm = LocationsViewModel(
			location: location.location,
			locationText: location.name)
		
		cell.configure(with: vm)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView,
							didSelectRowAt indexPath: IndexPath) {
		let location = locations[indexPath.row]
		delegate?.controller(self, didAddLocation: location)
		navigationController?.popViewController(animated: true)
	}
}

extension AddLocationViewController: UISearchBarDelegate {
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		locations = []
		tableView.reloadData()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		geocode(address: searchBar.text)
	}
}

protocol AddLocationViewControllerDelegate: class {
	func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}
