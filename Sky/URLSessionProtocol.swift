//
//  URLSessionProtocol.swift
//  Sky
//
//  Created by 张留岗 on 5/31/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
	typealias dataTasHandler = (Data?, URLResponse?, Error?) -> Void
	
	func dataTask(with request: URLRequest,
				  completionHandler: @escaping dataTasHandler) -> URLSessionDataTaskProtocol
}


extension URLSession: URLSessionProtocol {
	func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.dataTasHandler) -> URLSessionDataTaskProtocol {
		return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
	}
}
