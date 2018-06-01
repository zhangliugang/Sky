//
//  ViewController.swift
//  Sky
//
//  Created by Mars on 28/09/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
	
	var currentWeatherViewController: CurrentWeatherViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupActiveNotification()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		guard let destination = segue.destination as? CurrentWeatherViewController else {
			fatalError("Invalid destination view controller!")
		}
		if identifier == "segueCurrentWeather" {
			destination.delegate = self
			destination.viewModel = CurrentWeatherViewModel()
			currentWeatherViewController = destination
		}
	}
	
	private var currentLocation: CLLocation? {
		didSet {
			fetchCity()
			fetchWeather()
		}
	}
	
	private lazy var locationManager: CLLocationManager = {
		let manager = CLLocationManager()
		manager.distanceFilter = 1000
		manager.desiredAccuracy = 1000
		return manager
	}()
	
	private func requestLocation() {
		locationManager.delegate = self
		
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			locationManager.requestLocation()
		} else {
			locationManager.requestWhenInUseAuthorization()
		}
	}

	private func setupActiveNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
	}

	@objc func applicationDidBecomeActive(notification: Notification) {
		requestLocation()
	}
	
	private func fetchCity() {
		guard let currentLocation = currentLocation else {
			return
		}
		
		CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
			if let error = error {
				dump(error)
			} else if let city = placemarks?.first?.locality {
				// TODO:
				let location = Location(name: city, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
				self.currentWeatherViewController.viewModel?.locatoin = location
			}
		}
	}
	
	private func fetchWeather() {
		guard let currentLocation = currentLocation else { return }
		
		let lat = currentLocation.coordinate.latitude
		let lon = currentLocation.coordinate.longitude
		
		WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon) { (response, error) in
			if let error = error {
				dump(error)
			} else if let response = response {
				self.currentWeatherViewController.viewModel?.weather = response
			}
		}
	}
}

extension RootViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			currentLocation = location
			manager.delegate = nil
			manager.stopUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			manager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		dump(error)
	}
}

extension RootViewController: CurrentWeatherViewControllerDelegate {
	func locationButtonPressed(controller: CurrentWeatherViewController) {
		print("Open locations.")
	}
	
	func settingButtonPressed(controller: CurrentWeatherViewController) {
		print("Open settings.")
	}
}
