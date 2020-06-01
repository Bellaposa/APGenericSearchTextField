//
//  CustomCompoundPredicate.swift
//  APSearchTextField
//
//  Created by Antonio Posabella on 31/05/2020.
//

import Foundation


// MARK: - Compound Predicate
/// AND
/// - Parameters:
///   - left: left Predicate
///   - right: right Predicate
/// - Returns: Compound predicate of type AND
public func && <LeftPredicate: PredicateProtocol, RightPredicate: PredicateProtocol>(left: LeftPredicate, right: RightPredicate) -> Compound<LeftPredicate.Root> where LeftPredicate.Root == RightPredicate.Root {
	Compound(type: .and, subpredicates: [left, right])
}

/// OR
/// - Parameters:
///   - left: left Predicate
///   - right: right Predicate
/// - Returns: Compound predicate of type OR
public func || <LeftPredicate: PredicateProtocol, RightPredicate: PredicateProtocol>(left: LeftPredicate, right: RightPredicate) -> Compound<LeftPredicate.Root> where LeftPredicate.Root == RightPredicate.Root {
	Compound(type: .or, subpredicates: [left, right])
}

/// NOT
/// - Parameters:
///   - left: left Predicate
/// - Returns: Compound predicate of type NOT
public prefix func ! <LeftPredicate: PredicateProtocol>(left: LeftPredicate) -> Compound<LeftPredicate.Root> {
	Compound(type: .not, subpredicates: [left])
}
