//
//  SettingsTableViewCell.swift
//  Sky
//
//  Created by August on 6/3/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SettingsTableViewCell"
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
