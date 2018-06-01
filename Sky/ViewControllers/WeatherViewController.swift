//
//  WeatherViewController.swift
//  Sky
//
//  Created by 张留岗 on 6/1/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
	@IBOutlet weak var weatherContainerView: UIView!
	@IBOutlet weak var loadingFailedLabel: UILabel!
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
	}
	
	func setupView() {
		weatherContainerView.isHidden = true
		loadingFailedLabel.isHidden = true
		activityIndicatorView.startAnimating()
		activityIndicatorView.hidesWhenStopped = true
	}
	
}
