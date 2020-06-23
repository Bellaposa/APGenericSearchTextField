//
//  ViewController.swift
//  APGenericSearchTextField
//
//  Created by Bellaposa on 05/31/2020.
//  Copyright (c) 2020 Bellaposa. All rights reserved.
//

import UIKit
import APGenericSearchTextField

class ProgrammaticallyExampleViewController: UIViewController {

	var persons = Person.generateRandomPerson()

	override func viewDidLoad() {
		super.viewDidLoad()
		let frame = CGRect(x: 150, y: 150, width: 200, height: 20)

		let searchTextField = GenericSearchTextField(model: persons, frame: frame) { [weak self] (person, cell) -> PersonTableViewCell in
			guard let _ = self else { return cell }
			cell.nameLabel?.text = person.name
			return cell
		}

		searchTextField.placeholder = "Type Here"
		searchTextField.filterOperator = .contains
		searchTextField.propertyToFilter = \.name

		searchTextField.singleItemHandler = { [weak self] value in
			guard let _ = self else { return }
			searchTextField.text = value.name
		}
		
		searchTextField.isNibCell = true
		searchTextField.minCharactersNumberToStartFiltering = 3

		self.view.addSubview(searchTextField)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
