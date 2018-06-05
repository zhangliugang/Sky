//
//  SettingRepresentable.swift
//  Sky
//
//  Created by 张留岗 on 6/5/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

protocol SettingRepresentable {
	var labelText: String { get }
	var accessory: UITableViewCellAccessoryType { get }
}
