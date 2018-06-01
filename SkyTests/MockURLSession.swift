//
//  MockURLSession.swift
//  SkyTests
//
//  Created by 张留岗 on 5/31/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
@testable import Sky

class MockURLSession: URLSessionProtocol {
	var sessionDataTask = MockURLSessionDataTask()
	
	func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.dataTasHandler) -> URLSessionDataTaskProtocol {
		return sessionDataTask
	}
	
}
