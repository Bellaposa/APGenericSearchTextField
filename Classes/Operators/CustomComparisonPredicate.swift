//
//  CustomComparisonPredicate.swift
//  APSearchTextField
//
//  Created by Antonio Posabella on 31/05/2020.
//

import Foundation


/// Equal
/// - Parameters:
///   - keyPath: KeyPath<Root, Element>
///   - value: value to compare
/// - Returns: Comparison
public func == <Element: Equatable, Root, Value: KeyPath<Root, Element>>(keyPath: Value, value: Element) -> Comparison<Root> {
	Comparison(keyPath, .equalTo, value)
}

infix operator ⊂
/// Contains operator
/// - Parameters:
///   - keyPath: KeyPath<Root, Element>
///   - value: value to compare
/// - Returns: Comparison
public func ⊂ <Element: Equatable, Root, Value: KeyPath<Root, Element>>(keyPath: Value, value: Element) -> Comparison<Root> {
	Comparison(keyPath, .contains, value)
}
