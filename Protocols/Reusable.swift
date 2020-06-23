//
//  Reusable.swift
//  APGenericSearchTextField
//
//  Created by Antonio Posabella on 23/06/2020.
//

import Foundation
import UIKit

protocol Reusable {}

/// MARK: - UITableView
extension Reusable where Self: UITableViewCell  {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
	
	static var nib: UINib? {
		return UINib(nibName: String(describing: self), bundle: nil)
	}
}


extension UITableViewCell: Reusable {}

extension UITableView {

	func register<T: UITableViewCell>(_ : T.Type) {
		register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
	}

	

	func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			fatalError(ErrorMessage.cellIdentifierError.description)
		}
		return cell
	}
}
