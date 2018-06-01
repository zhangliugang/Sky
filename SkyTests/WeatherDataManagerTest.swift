//
//  WeatherDataManagerTest.swift
//  SkyTests
//
//  Created by 张留岗 on 5/31/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import XCTest
@testable import Sky

class WeatherDataManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_weatherDataAt_starts_the_session() {
		let session = MockURLSession()
		let dataTask = MockURLSessionDataTask()
		session.sessionDataTask = dataTask
		let url = URL(string: "https://darksky.net")!
		let manager = WeatherDataManager(baseURL: url, urlSession: session)
		manager.weatherDataAt(latitude: 52, longitude: 100) { (_, _) in
			
		}
		
		XCTAssert(session.sessionDataTask.isResumeCalled)
	}
    
}
