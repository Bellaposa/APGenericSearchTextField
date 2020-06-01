import XCTest
import APGenericSearchTextField

class Tests: XCTestCase {

	private var persons: [Person] = []
	private var textField: GenericSearchTextField<Any>?

	override func setUp() {
		super.setUp()
		persons = [Person(name: "LeBron", surname: "James"), Person(name: "Larry", surname: "Bird")]
		let frame = CGRect(x: 150, y: 150, width: 200, height: 20)
		textField = GenericSearchTextField(model: persons, frame: frame, cellConfigurator: { (_, _) in
		})
	}

	override func tearDown() {
		super.tearDown()
	}

	func testEqualName() {

		if let person = persons.filter(operation: \Person.name == "LeBron") {
			XCTAssertEqual(person.first!.name, "LeBron")
		}
	}

	func testContainsName() {
		if let person = persons.filter(operation: \Person.name ⊂ "Le") {
			XCTAssertEqual(person.first!.name, "LeBron")
		}
	}
}

private class Person: NSObject {
	@objc let name: String
	@objc let surname: String

	init(name: String, surname: String) {
		self.name = name
		self.surname = surname
	}
}
