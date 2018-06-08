//
//  CLLocationManager+Rx.swift
//  Sky
//
//  Created by 张留岗 on 6/8/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

extension CLLocationManager: HasDelegate {
	public typealias Delegate = CLLocationManagerDelegate
}

class CLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
	weak private(set) var locationManager: CLLocationManager?
	
	init(locationManager: ParentObject) {
		self.locationManager = locationManager
		super.init(parentObject: locationManager, delegateProxy: CLLocationManagerDelegateProxy.self)
	}
	
	static func registerKnownImplementations() {
		self.register { CLLocationManagerDelegateProxy(locationManager: $0) }
	}
}

extension Reactive where Base: CLLocationManager {
	var delegate: CLLocationManagerDelegateProxy {
		return CLLocationManagerDelegateProxy.proxy(for: base)
	}
	
	var didUpdateLocations: Observable<[CLLocation]> {
		let sel = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
		return delegate.methodInvoked(sel).map { parameters in
			parameters[1] as! [CLLocation]
		}
	}
}
