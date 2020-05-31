import XCTest
import APGenericSearchTextField

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testEqualName() {
		let persons = [Person(name: "LeBron", surname: "James"), Person(name: "Larry", surname: "Bird")]
		if let person = persons.filter(operation: \Person.name == "LeBron") {
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

private class Person: NSObject {
	@objc let name: String
	@objc let surname: String
	
	init(name: String, surname: String) {
		self.name = name
		self.surname = surname
	}
}
