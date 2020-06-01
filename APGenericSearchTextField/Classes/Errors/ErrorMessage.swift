//
//  Errors.swift
//  APGenericSearchTextField
//
//  Created by Antonio Posabella on 01/06/2020.
//

import Foundation

enum ErrorMessage {
	case missingPropertyToFilter
	case missingFilterOperator
}

extension ErrorMessage {
	var description: String {
		switch self {
			case .missingPropertyToFilter:
				return "Missing: Property to filter"
			case .missingFilterOperator:
				return "Missing: Filter operator"
		}
	}
}
