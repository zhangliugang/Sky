//
//  LocationTableViewCell.swift
//  Sky
//
//  Created by 张留岗 on 6/5/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
	
	static let reuseIdentifier = "locationCell"
	@IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	func configure(with vm: LocationRepresentable) {
		label.text = vm.labelText
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
