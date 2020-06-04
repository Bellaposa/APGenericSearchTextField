//
//  StoryboardExampleViewController.swift
//  APGenericSearchTextField_Example
//
//  Created by Antonio Posabella on 04/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import APGenericSearchTextField

/// 1 - Declare your custom "UITextField" that extends GenericSearchTextField and add it to storyboard
class SearchTextField: GenericSearchTextField<Person>{}

class StoryboardExampleViewController: UIViewController {

	/// 2: - DEFINE OUTLET
	/// When creating outlet of type `SearchTextField` XCode will return an error
	/// It's important to change TextField type from `SearchTextField` to `UIView`
	@IBOutlet weak var textField: UIView!

	/// 3: - DEFINE A VARIABLE of type `GenericSearchTextField`
	/// cast your variable with `GenericSearchTextField`
	/// Now your are able to use your variable
	var searchTextField: GenericSearchTextField<Person> {
		return textField as! GenericSearchTextField
	}

	var persons = Person.generateRandomPerson()
	override func viewDidLoad() {
        super.viewDidLoad()

		searchTextField.placeholder = "Type Here"
		searchTextField.filterOperator = .contains
		searchTextField.propertyToFilter = \.name
		searchTextField.cellConfigurator = {
			(person, cell) in
			cell.textLabel?.text = person.name
		}
		searchTextField.model = persons

		searchTextField.singleItemHandler = { [weak self] value in
			print(value)
			self?.searchTextField.text = value.name
		}
    }
}
