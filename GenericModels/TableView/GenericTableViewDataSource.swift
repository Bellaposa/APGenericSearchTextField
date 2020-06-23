//
//  TableViewDataSource.swift
//  APGenericSearchTextField
//
//  Created by Antonio Posabella on 01/06/2020.
//

import UIKit
/// TableView DataSource
class GenericTableViewDataSource<Model, Cell>: NSObject, UITableViewDataSource where Cell: BaseTableViewCell<Model> {
	/// Model
	private var models: [Model] = []
	/// Cell Configurator
	private let cellConfigurator: CellConfigurator
	/// Search Results
	open var searchResults: [Model] = []

	/// Init
	init(models: [Model],
		 cellConfigurator: @escaping CellConfigurator) {
		self.models = models
		self.cellConfigurator = cellConfigurator
	}
	
	/// Table View Methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResults.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.register(Cell.self)
		let cell: Cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
		return cellConfigurator(getModelAt(indexPath), cell)
	}
}
// MARK : - TableViewDataSource
extension GenericTableViewDataSource {

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
		print(searchResults.description)
	}
}

extension GenericTableViewDataSource: TextFieldHelperProtocol {}
