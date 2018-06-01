//
//  Configuration.swift
//  Sky
//
//  Created by 张留岗 on 5/31/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

struct API {
	static let key = "b0259b0da1bc2a61a61abc57dd29879e"
	static let baseUrl = URL(string: "https://api.darksky.net/forecast")!
	static let authenticateUrl = baseUrl.appendingPathComponent(key)
}
