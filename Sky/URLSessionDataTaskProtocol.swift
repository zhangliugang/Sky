//
//  URLSessionDataTaskProtocol.swift
//  Sky
//
//  Created by 张留岗 on 5/31/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
	func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
