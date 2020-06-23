//
//  PersonTableViewCell.swift
//  APGenericSearchTextField_Example
//
//  Created by Antonio Posabella on 23/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import APGenericSearchTextField

class PersonTableViewCell: BaseTableViewCell<Person> {

	@IBOutlet weak var nameLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension PersonTableViewCell {
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}

	static var identifier: String {
		return String(describing: self)
	}
}

