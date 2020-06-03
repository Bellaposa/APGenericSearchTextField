//
//  TableViewDataSource.swift
//  APGenericSearchTextField
//
//  Created by Antonio Posabella on 01/06/2020.
//

import UIKit
/// TableView DataSource
class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
	/// Model
	private var models: [Model] = []
	/// TableView identifier
	private let reuseIdentifier: String
	/// Cell Configurator
	private let cellConfigurator: CellConfigurator
	/// Search Results
	open var searchResults: [Model] = []

	/// Init
	init(models: [Model],
		 reuseIdentifier: String,
		 cellConfigurator: @escaping CellConfigurator) {
		self.models = models
		self.reuseIdentifier = reuseIdentifier
		self.cellConfigurator = cellConfigurator
	}
	
	/// Table View Methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResults.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let model = getModelAt(indexPath)
		
		var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
		cell = cell == nil ? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier) : UITableViewCell()
		
		cellConfigurator(model, cell!)
		
		return cell!

	}
}
// MARK : - TableViewDataSource
extension TableViewDataSource {

	/// Returns the Model at indexPath
	/// - Parameter indexPath: indexPath
	/// - Returns: Model at indexPath
	func getModelAt(_ indexPath: IndexPath) -> Model {
		return searchResults[indexPath.item]
	}

	/// Filters model by NSPredicate
	/// - Parameter query: predicate to use
	func search(query: NSPredicate) {
		searchResults = models.filter(operation: query) ?? []
		Console.debug(searchResults.description)
	}
}

extension TableViewDataSource: TextFieldHelperProtocol {}
