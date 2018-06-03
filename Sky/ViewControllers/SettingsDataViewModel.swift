//
//  SettingsDataViewModel.swift
//  Sky
//
//  Created by August on 6/3/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

struct SettingsDataViewModel {
    let dateMode: DateMode
    
    var labelText: String {
        return dateMode == .text ? "Fri, 01 December" : "F, 12/01"
    }
    
    var accessary: UITableViewCellAccessoryType {
        if UserDefaults.dateMode() == dateMode {
            return .checkmark
        } else {
            return .none
        }
    }
}
