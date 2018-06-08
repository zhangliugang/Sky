//
//  WeatherDataManager.swift
//  Sky
//
//  Created by 张留岗 on 5/31/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum DataManagerError: Error {
	case failedRequest
	case invalidResponse
	case unknown
}

final class WeatherDataManager {
	internal let baseURL: URL
	internal let urlSession: URLSessionProtocol
	
	internal init(baseURL: URL, urlSession: URLSessionProtocol) {
		self.baseURL = baseURL
		self.urlSession = urlSession
	}
	
	static let shared = WeatherDataManager(baseURL: API.authenticateUrl, urlSession: URLSession.shared)
	
	typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void
	
	func weatherDataAt(latitude: Double, longitude: Double) -> Observable<WeatherData> {
		let url = baseURL.appendingPathComponent("\(latitude),\(longitude)")
		var request = URLRequest(url: url)
		
		request.setValue("applicatoin/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "GET"
		
		return (self.urlSession as! URLSession).rx.data(request: request)
			.map {
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .secondsSince1970
				return try decoder.decode(WeatherData.self, from: $0)
		}
	}
}
