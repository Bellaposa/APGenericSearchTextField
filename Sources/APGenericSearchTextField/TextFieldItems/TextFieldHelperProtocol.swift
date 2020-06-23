//
//  GenericSearchTextFieldHelper.swift
//  APGenericSearchTextField
//
//  Created by Antonio Posabella on 01/06/2020.
//

import UIKit
/// Custom Protocol
public protocol TextFieldHelperProtocol {
	associatedtype Model
	associatedtype Cell
	typealias ItemHandler = (_ filtered: [Model]) -> Void
	typealias SingleItemHandler = (_ filtered: Model) -> Void
	typealias CellConfigurator = (Model, Cell) -> Cell
	typealias StoppedTypingHandler = (() -> Void)?
}
