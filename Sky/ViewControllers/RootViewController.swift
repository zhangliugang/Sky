//
//  ViewController.swift
//  Sky
//
//  Created by Mars on 28/09/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class RootViewController: UIViewController {
	private var bag = DisposeBag()
	
	var currentWeatherViewController: CurrentWeatherViewController!
    var weekWeatherViewController: WeekWeatherViewController!
    
    private let segueSettings = "segueSetting"
	private let segueLocatoin = "segueLocation"

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupActiveNotification()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }
		
		if identifier == "segueCurrentWeather" {
            guard let destination = segue.destination as? CurrentWeatherViewController else {
                fatalError("Invalid destination view controller!")
            }
			destination.delegate = self
			currentWeatherViewController = destination
		}
        if identifier == "segueWeekWeather" {
            guard let destination = segue.destination as? WeekWeatherViewController else {
                fatalError("Invalid destination view controller!")
            }
            weekWeatherViewController = destination
        }
        if identifier == segueSettings  {
            guard let navigationController =
                segue.destination as? UINavigationController else {
                    fatalError("Invalid destination view controller!")
            }
            
            guard let destination =
                navigationController.topViewController as?
                SettingViewController else {
                    fatalError("Invalid destination view controller!")
            }
            
            destination.delegate = self
        }
		if identifier == segueLocatoin {
			guard let navigationController = segue.destination as? UINavigationController,
				let destination = navigationController.topViewController as? LocationViewController else {
					fatalError("Invalid destination view controller!")
			}
			destination.delegate = self
			destination.currentLocation = currentLocation
		}
	}
    
    @IBAction func unwindToRootViewController(
        segue: UIStoryboardSegue) {
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
//			locationManager.requestLocation()
			self.locationManager.startUpdatingLocation()
			self.locationManager.rx
				.didUpdateLocations
				.take(1)
				.subscribe(onNext: {
					self.currentLocation = $0.first
				}).disposed(by: bag)
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
				self.currentWeatherViewController.locationVM
					.accept(CurrentLocationViewModel(location: location))
			}
		}
	}
	
	private func fetchWeather() {
		guard let currentLocation = currentLocation else { return }
		
		let lat = currentLocation.coordinate.latitude
		let lon = currentLocation.coordinate.longitude
		
		let weather = WeatherDataManager.shared
			.weatherDataAt(latitude: lat, longitude: lon)
			.share(replay: 1, scope: .whileConnected)
			.observeOn(MainScheduler.instance)
		weather.map { CurrentWeatherViewModel(weather: $0) }
			.bind(to: self.currentWeatherViewController.weatherVM)
			.disposed(by: bag)
		weather.map { WeekWeatherViewModel(weatherData: $0.daily.data) }
			.subscribe(onNext: {
				self.weekWeatherViewController.viewModel = $0
			})
			.disposed(by: bag)
	}
}

extension RootViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
            print("\(location.coordinate.latitude),\(location.coordinate.longitude)")
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
		performSegue(withIdentifier: segueLocatoin, sender: nil)
	}
	
	func settingButtonPressed(controller: CurrentWeatherViewController) {
        performSegue(withIdentifier: segueSettings, sender: nil)
	}
}

extension RootViewController: SettingsViewControllerDelegate {
    private func reloadUI() {
        currentWeatherViewController.updateView()
        weekWeatherViewController.updateView()
    }
    
    func controllerDidChangeTimeMode(
        controller: SettingViewController) {
        reloadUI()
    }
    
    func controllerDidChangeTemperatureMode(
        controller: SettingViewController) {
        reloadUI()
    }
}

extension RootViewController: LocationViewControllerDelegate {
	func controller(_ controller: LocationViewController, didSelectLocation location: CLLocation) {
		currentLocation = location
	}
}
