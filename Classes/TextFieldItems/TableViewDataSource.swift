//
//  TableViewDataSource.swift
//  APGenericSearchTextField
//
//  Created by Antonio Posabella on 01/06/2020.
//

import UIKit

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
	
	typealias CellConfigurator = (Model, UITableViewCell) -> Void
	
	private var models: [Model] = []
	private var searchResults: [Model] = []
	private let reuseIdentifier: String
	private let cellConfigurator: CellConfigurator
	
	init(models: [Model],
		 reuseIdentifier: String,
		 cellConfigurator: @escaping CellConfigurator) {
		self.models = models
		self.reuseIdentifier = reuseIdentifier
		self.cellConfigurator = cellConfigurator
	}
	
	
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

extension TableViewDataSource {
	fileprivate func getModelAt(_ indexPath: IndexPath) -> Model {
		return searchResults[indexPath.item]
	}
	
	func search(query: NSPredicate) {
		searchResults = models.filter(operation: query) ?? []
		print(searchResults)
	}
}
