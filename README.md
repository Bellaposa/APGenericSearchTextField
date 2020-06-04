# APGenericSearchTextField

[![CI Status](https://img.shields.io/travis/Bellaposa/APGenericSearchTextField.svg?style=flat)](https://travis-ci.org/Bellaposa/APGenericSearchTextField)
[![Version](https://img.shields.io/cocoapods/v/APGenericSearchTextField.svg?style=flat)](https://cocoapods.org/pods/APGenericSearchTextField)
[![License](https://img.shields.io/cocoapods/l/APGenericSearchTextField.svg?style=flat)](https://cocoapods.org/pods/APGenericSearchTextField)
[![Platform](https://img.shields.io/cocoapods/p/APGenericSearchTextField.svg?style=flat)](https://cocoapods.org/pods/APGenericSearchTextField)

### Context

Swift 4 introduced a new type called KeyPath. It allows to access the properties of an object.  
For instance:

`let helloWorld = "HelloWorld"`
`let keyPathCount = \String.count`

`let count = helloWorld[keyPath: keyPathCount]`  
`//count == 10`  

The syntax can be very concise, it supports type inference and property chaining.

## Purpose
Long time ago, I had the necessity to create a SearchTextField, and I thought it would be nice to apply this concept to it.  

### Under The Hood
* KeyPath
* NSPredicate 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Details
You have to follow few simple steps:  

1.  Define your Model by subclassing NSObject
1.  Define property by using @objc 
1.  Select filterOperator 
1.  Select propertyToFilter
2. 	 Define your cellConfigurator

### Model 
``` swift
class Person: NSObject {
	@objc let name: String
	@objc let surname: String

	init(name: String, surname: String) {
		self.name = name
		self.surname = surname
	}
}
```
### Filter Operator
At the moment only two operators are supported

1. Contains 
2. Equal

### Property To Filter
Using keyPath you can choose what field of object you want to compare

For istance: `\.name` if you want to filter your array objects by name 


### Cell Configurator

You can configure your cell in this way  

```swift 

searchTextField.cellConfigurator = { [weak self] (person, cell) in
			cell.textLabel?.text = person.name
}
```

### Customization
It's possible to customize your suggestion TableView with these values

``` swift 
tableXOffset
tableYOffset
tableCornerRadius
tableBottomMargin
maxResultsListHeight
minCharactersNumberToStartFiltering
```

**singleItemHandler** will return the selected object in tableView

```swift 
singleItemHandler = { [weak self] value in
		print(value)
}
```

### Storyboard
Storyboards have a problem with having a generic class. The thing is that Interface Builder communicates to the ViewController through the `Objective-C` runtime. Because of this, InterfaceBuilder is limited to the features that Objective-C provides. In this case, generics are not supported. By the way there is a workaround to use generic class with storyboard.  

You need to:  

* Declare a custom `UITextField` that extends `GenericSearchTextField` and add it to storyboard
`i.e. class SearchTextField: GenericSearchTextField<Person>{}`
* Define Outlet 
	- Defining an outlet of type `SearchTextField`, XCode will report an error. It's important to change type from `SearchTextField` to `UIView`
	- After: `@IBOutlet weak var textField: SearchTextField!`
	- Before: `@IBOutlet weak var textField: UIView!`	

* Define a variable of type `GenericSearchTextField`
 	- Cast your variable with `GenericSearchTextField`
	- Now your are able to use your variable

```swift 
var searchTextField: GenericSearchTextField<Person> {
		return textField as! GenericSearchTextField
}
```
* Use `searchTextField` variable  


### Bugs
The library is in alpha stage  
Found a bug? Simple Pull Request

### TODOs
* Better test coverage 
* Better Filter management
* Custom cell support
* <s>Storyboard Support</s>


### Demo
Check out the Example project.
You will find two examples with programmatically and storyboard.




## Requirements

## Installation

APGenericSearchTextField is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'APGenericSearchTextField'
```

## Author

Bellaposa, antonioposabella91@gmail.com

## License

APGenericSearchTextField is available under the MIT license. See the LICENSE file for more info.
