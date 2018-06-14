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
		
		let MAX_ATTEMPTS = 4
		
		return (self.urlSession as! URLSession)
			.rx
			.data(request: request)
			.map {
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .secondsSince1970
				return try decoder.decode(WeatherData.self, from: $0)
			}
			.materialize()
			.do(onNext: { print("Materialize: \($0)") })
			.dematerialize()
			.retryWhen { e in e.enumerated().flatMap {
				(attempt, error) -> Observable<Int> in
					if (attempt >= MAX_ATTEMPTS) {
						print("------- \(attempt + 1) attempt -------")
						return Observable.error(error)
					} else {
						print("-------- \(attempt + 1) Retry --------")
						return Observable<Int>.timer(Double(attempt), scheduler: MainScheduler.instance)
							.take(1)
					}
				}
			}
			.catchErrorJustReturn(WeatherData.invalid)
		
	}
}

//extension URLSession {
//
//	func dataTask(with url: URL, completionHandler: @escaping (String?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//		fatalError()
//	}
//
//	func  start()  {
//		let url = URL(string: "")!
//		URLSession.shared.dataTask(with: url) { (d: String?, r, e) in
//
//		}.resume()
//	}
//}
