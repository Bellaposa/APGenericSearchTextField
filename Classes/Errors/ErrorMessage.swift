//
//  Errors.swift
//  APGenericSearchTextField
//
//  Created by Antonio Posabella on 01/06/2020.
//

import Foundation

enum ErrorMessage {
	case propertyToFilter
}

extension ErrorMessage {
	var description: String {
		switch self {
			case .propertyToFilter:
				return "Missing: Property to filter"
			default:
			break
		}
	}
}
