//
//  CurrentWeatherViewController.swift
//  Sky
//
//  Created by 张留岗 on 6/1/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CurrentWeatherViewController: WeatherViewController {
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var weatherIcon: UIImageView!
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	private var bag = DisposeBag()
	
	weak var delegate: CurrentWeatherViewControllerDelegate?
	
	var weatherVM: BehaviorRelay<CurrentWeatherViewModel> = BehaviorRelay(value: CurrentWeatherViewModel.empty)
	var locationVM: BehaviorRelay<CurrentLocationViewModel> = BehaviorRelay(value: CurrentLocationViewModel.empty)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let viewModel = Observable
			.combineLatest(locationVM, weatherVM) {
				return ($0, $1)
			}
			.filter {
				let (location, weather) = $0
				return !(location.isEmpty) && !(weather.isEmpty)
			}
			.share(replay: 1, scope: .whileConnected)
//			.observeOn(MainScheduler.instance)
			.asDriver(onErrorJustReturn: (CurrentLocationViewModel.empty, CurrentWeatherViewModel.empty))
		
		viewModel.map { _ in false }
			.drive(self.activityIndicatorView.rx.isAnimating)
			.disposed(by: bag)
		viewModel.map { _ in false }
			.drive(self.weatherContainerView.rx.isHidden)
			.disposed(by: bag)
		
		viewModel.map { $0.0.city }
			.drive(self.locationLabel.rx.text)
			.disposed(by: bag)
		
		viewModel.map { $0.1.temperature }
			.drive(self.temperatureLabel.rx.text)
			.disposed(by: bag)
		viewModel.map { $0.1.weatherIcon }
			.drive(self.weatherIcon.rx.image)
			.disposed(by: bag)
		viewModel.map { $0.1.humidity }
			.drive(self.humidityLabel.rx.text)
			.disposed(by: bag)
		viewModel.map { $0.1.summary }
			.drive(self.summaryLabel.rx.text)
			.disposed(by: bag)
		viewModel.map { $0.1.date }
			.drive(self.dateLabel.rx.text)
			.disposed(by: bag)
	}
	
	@IBAction func locationButtonPressed(_ sender: UIButton) {
		delegate?.locationButtonPressed(controller: self)
	}
	
	@IBAction func settingButtonPressed(_ sender: UIButton) {
		delegate?.settingButtonPressed(controller: self)
	}
	
	func updateView () {
		weatherVM.accept(weatherVM.value)
		locationVM.accept(locationVM.value)
	}

}

extension Double {
	func toCelsius() -> Double {
		return (self - 32.0) / 1.8
	}
}

protocol CurrentWeatherViewControllerDelegate: class {
	func locationButtonPressed(controller: CurrentWeatherViewController)
	func settingButtonPressed(controller: CurrentWeatherViewController)
}
