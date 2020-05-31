//
//  KeyPathOperators.swift
//  APSearchTextField
//
//  Created by Antonio Posabella on 31/05/2020.
//

import Foundation

// MARK: - Custom Predicate Types
public protocol PredicateProtocol: NSPredicate { associatedtype Root }
public final class Compound<Root>: NSCompoundPredicate, PredicateProtocol {}
public final class Comparison<Root>: NSComparisonPredicate, PredicateProtocol {}

// MARK: - Init
extension Comparison {
	convenience init<Element>(_ keyPath: KeyPath<Root, Element>, _ comparisonPredicate: NSComparisonPredicate.Operator, _ value: Any?) {
		let leftExpression = \Root.self == keyPath ? NSExpression.expressionForEvaluatedObject() : NSExpression(forKeyPath: keyPath)
		let rightExpression = NSExpression(forConstantValue: value)
		
		self.init(leftExpression: leftExpression, rightExpression: rightExpression, modifier: .direct, type: comparisonPredicate)
	}
}
