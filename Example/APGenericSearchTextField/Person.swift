//
//  Person.swift
//  APGenericSearchTextField_Example
//
//  Created by Antonio Posabella on 01/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

class Person: NSObject {
	@objc let name: String
	@objc let surname: String

	init(name: String, surname: String) {
		self.name = name
		self.surname = surname
	}

	class func generateRandomPerson() -> [Person] {
		return [
			Person(name: "Kobe", surname: "Bryant"),
			Person(name: "LeBron", surname: "James"),
			Person(name: "Magic", surname: "Johnson"),
			Person(name: "Larry", surname: "Bird"),
			Person(name: "Joe", surname: "Johnson"),
			Person(name: "Michael", surname: "Jordan"),
			Person(name: "Micky", surname: "James"),
			Person(name: "Larry", surname: "Bry")
		]
	}
}
