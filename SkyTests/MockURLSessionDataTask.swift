//
//  MockURLSessionDataTask.swift
//  SkyTests
//
//  Created by 张留岗 on 5/31/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
@testable import Sky

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
	private(set) var isResumeCalled = false
	
	func resume() {
		self.isResumeCalled = true
	}
}
