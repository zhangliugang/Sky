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
	
	var viewModel: AddLocationViewModel!
	weak var delegate: AddLocationViewControllerDelegate?
	@IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Add a location"
		viewModel = AddLocationViewModel()
		viewModel.locationDidChange = { [unowned self] locations in
			self.tableView.reloadData()
		}
		viewModel.queryingStatusDidChange = {
			[unowned self] isQuerying in
			if isQuerying {
				self.title = "Searching..."
			} else {
				self.title = "Add a location"
			}
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		searchBar.becomeFirstResponder()
	}

}

extension AddLocationViewController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfLocations
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: LocationTableViewCell.reuseIdentifier,
			for: indexPath) as? LocationTableViewCell else {
				fatalError("Unexpected table view cell")
		}
		
		if let vm = viewModel.locationViewModel(at: indexPath.row) {
			cell.configure(with: vm)
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView,
							didSelectRowAt indexPath: IndexPath) {
		guard let location = viewModel.location(at: indexPath.row) else { return }
		delegate?.controller(self, didAddLocation: location)
		navigationController?.popViewController(animated: true)
	}
}

extension AddLocationViewController: UISearchBarDelegate {
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		viewModel.queryText = searchBar.text ?? ""
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		viewModel.queryText = searchBar.text ?? ""
	}
}

protocol AddLocationViewControllerDelegate: class {
	func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}
