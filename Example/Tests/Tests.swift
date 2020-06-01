import XCTest
import APGenericSearchTextField

class Tests: XCTestCase {
	
	private var persons: [Person] = []
	
	override func setUp() {
		super.setUp()
		persons = [Person(name: "LeBron", surname: "James"), Person(name: "Larry", surname: "Bird")]
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
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure() {
			// Put the code you want to measure the time of here.
		}
	}
	
}



fileprivate class Person: NSObject {
	@objc let name: String
	@objc let surname: String
	
	init(name: String, surname: String) {
		self.name = name
		self.surname = surname
	}
}

