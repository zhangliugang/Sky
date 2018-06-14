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
	@IBOutlet weak var retryBtn: UIButton!
	
	private var bag = DisposeBag()
	
	weak var delegate: CurrentWeatherViewControllerDelegate?
	
	var weatherVM: BehaviorRelay<CurrentWeatherViewModel> = BehaviorRelay(value: CurrentWeatherViewModel.empty)
	var locationVM: BehaviorRelay<CurrentLocationViewModel> = BehaviorRelay(value: CurrentLocationViewModel.empty)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let combined = Observable
			.combineLatest(locationVM, weatherVM)
			.share(replay: 1, scope: .whileConnected)
		
		let viewModel = combined.filter {
			self.shouldDisplayWeatherContainer(locationVM: $0.0, weatherVM: $0.1)
		}.asDriver(onErrorJustReturn: (.empty, .empty))
		
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
		
		combined.map {
			self.shouldHideWeatherContainer(locationVM: $0.0, weatherVM: $0.1)
		}
		.asDriver(onErrorJustReturn: true)
		.drive(self.weatherContainerView.rx.isHidden)
		.disposed(by: bag)
		
		combined.map {
			self.shouldHideActivityIndicator(locationVM: $0.0, weatherVM: $0.1)
		}
		.asDriver(onErrorJustReturn: false)
		.drive(self.activityIndicatorView.rx.isHidden)
		.disposed(by: bag)
		
		combined.map {
			self.shouldAnimateActivityIndicator(locationVM: $0.0, weatherVM: $0.1)
		}
		.asDriver(onErrorJustReturn: true)
		.drive(self.activityIndicatorView.rx.isAnimating)
		.disposed(by: bag)
		
		let errorCond = combined.map {
			self.shouldDisplayErrorPrompt(locationVM: $0.0, weatherVM: $0.1)
		}.asDriver(onErrorJustReturn: true)

		errorCond.map { !$0 }
			.drive(self.retryBtn.rx.isHidden)
			.disposed(by: bag)
		errorCond.map { !$0 }
			.drive(self.loadingFailedLabel.rx.isHidden)
			.disposed(by: bag)
		errorCond.map { _ in return "String.ok" }
			.drive(self.loadingFailedLabel.rx.text)
			.disposed(by: bag)
		
		self.retryBtn.rx.tap.subscribe(onNext: { _ in
			self.weatherVM.accept(.empty)
			self.locationVM.accept(.empty)
			
			(self.parent as? RootViewController)?.fetchCity()
			(self.parent as? RootViewController)?.fetchWeather()
		}).disposed(by: bag)
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


fileprivate extension CurrentWeatherViewController {
	func shouldDisplayWeatherContainer(
		locationVM: CurrentLocationViewModel,
		weatherVM: CurrentWeatherViewModel) -> Bool {
		return !locationVM.isEmpty &&
			!locationVM.isInvalid &&
			!weatherVM.isEmpty &&
			!weatherVM.isInvalid
	}
	
	func shouldHideWeatherContainer(
		locationVM: CurrentLocationViewModel,
		weatherVM: CurrentWeatherViewModel) -> Bool {
		return locationVM.isEmpty ||
			locationVM.isInvalid ||
			weatherVM.isEmpty ||
			weatherVM.isInvalid
	}
	
	func shouldHideActivityIndicator(
		locationVM: CurrentLocationViewModel,
		weatherVM: CurrentWeatherViewModel) -> Bool {
		return (!locationVM.isEmpty && !weatherVM.isEmpty) ||
			locationVM.isInvalid ||
			weatherVM.isInvalid
	}
	
	func shouldAnimateActivityIndicator(
		locationVM: CurrentLocationViewModel,
		weatherVM: CurrentWeatherViewModel) -> Bool {
		return locationVM.isEmpty || weatherVM.isEmpty
	}
	
	func shouldDisplayErrorPrompt(
		locationVM: CurrentLocationViewModel,
		weatherVM: CurrentWeatherViewModel) -> Bool {
		return locationVM.isInvalid || weatherVM.isInvalid
	}
}
