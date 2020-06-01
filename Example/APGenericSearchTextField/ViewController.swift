//
//  ViewController.swift
//  APGenericSearchTextField
//
//  Created by Bellaposa on 05/31/2020.
//  Copyright (c) 2020 Bellaposa. All rights reserved.
//

import UIKit
import APGenericSearchTextField

class ViewController: UIViewController {

	var persons = Person.generateRandomPerson()

	override func viewDidLoad() {
        super.viewDidLoad()

		let searchTextField = GenericSearchTextField(model: persons) { (person, cell) in
			cell.textLabel?.text = person.surname
		}

		searchTextField.placeholder = "Type Here"
		searchTextField.filterOperator = .contains
		searchTextField.propertyToFilter = \.surname

		searchTextField.singleItemHandler = { value in
			print(value)
		}
		
		self.view.addSubview(searchTextField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

