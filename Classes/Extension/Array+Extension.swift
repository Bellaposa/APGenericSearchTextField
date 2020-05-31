//
//  Array+Extension.swift
//  APSearchTextField
//
//  Created by Antonio Posabella on 31/05/2020.
//

import Foundation
// MARK: -
extension Array {
	/// filter(operation: NSPredicate)
	/// - Parameter operation: NSPredicate
	/// - Returns: array filtered according to  operation NSPredicate
	public func filter(operation: NSPredicate) -> [Element]? {
		let array = NSArray(array: self)
		return array.filtered(using: operation) as? [Element]
	}
}
