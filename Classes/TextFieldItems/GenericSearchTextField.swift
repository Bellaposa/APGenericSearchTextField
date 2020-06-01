//
//  GenericSearchTextFieldClass.swift
//  APGenericSearchTextField
//
//  Created by Antonio Posabella on 01/06/2020.
//

import UIKit

private enum Direction {
	case down
	case up
}

public class GenericSearchTextField<Model>: UITextField, UITableViewDelegate {
	public typealias CellConfigurator = (Model, UITableViewCell) -> Void

	fileprivate var datasource: TableViewDataSource<Model>?
	fileprivate let identifier: String = "APGenericSearchTextFieldCell"
	fileprivate var tableView: UITableView?
	fileprivate var shadowView: UIView?
	fileprivate var resultsListHeader: UIView?
	fileprivate var direction: Direction = .down
	fileprivate var keyboardFrame: CGRect?


	open var tableXOffset: CGFloat = 0.0
	open var tableYOffset: CGFloat = 0.0
	open var tableCornerRadius: CGFloat = 2.0
	open var tableBottomMargin: CGFloat = 10.0
	open var keyboardIsShowing = false
	open var maxResultsListHeight = 0
	open var minCharactersNumberToStartFiltering: Int = 0
	open var filterOperator: FilterOperator?

	open var propertyToFilter: KeyPath<Model, String>?


	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	public init(model: [Model], cellConfigurator: @escaping (CellConfigurator))  {
		self.datasource = TableViewDataSource(models: model, reuseIdentifier: identifier, cellConfigurator: cellConfigurator)
		super.init(frame: CGRect(x: 150,
								 y: 150,
								 width: 100,
								 height: 20)) // dummy size
		self.buildSearchTableView()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override open func layoutSubviews() {
		super.layoutSubviews()
		buildSearchTableView()
	}

	override open func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)

		self.addTarget(self, action: #selector(GenericSearchTextField.textFieldDidChange), for: .editingChanged)
		self.addTarget(self, action: #selector(GenericSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
		self.addTarget(self, action: #selector(GenericSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
		self.addTarget(self, action: #selector(GenericSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)

		NotificationCenter.default.addObserver(self, selector: #selector(GenericSearchTextField.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(GenericSearchTextField.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(GenericSearchTextField.keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)

	}
	@objc func textFieldDidChange() {

		buildSearchTableView()

		guard let property = propertyToFilter else {
			fatalError(ErrorMessage.propertyToFilter.description)
		}

		let predicate = filter(property, value: text!)
		datasource?.search(query: predicate)
		tableView?.reloadData()
	}

	@objc func textFieldDidBeginEditing() {}

	@objc func textFieldDidEndEditing() {}

	@objc func textFieldDidEndEditingOnExit() {}

	@objc func keyboardWillShow(_ notification: Notification) {}

	@objc func keyboardWillHide(_ notification: Notification) {}

	@objc func keyboardDidChangeFrame(_ notification: Notification) {}
}


extension GenericSearchTextField {
	// Create the filter table and shadow view
	fileprivate func buildSearchTableView() {
		guard let tableView = tableView, let shadowView = shadowView else {
			self.tableView = UITableView(frame: CGRect.zero)
			self.shadowView = UIView(frame: CGRect.zero)
			buildSearchTableView()
			return
		}

		tableView.layer.masksToBounds = true
		tableView.layer.borderWidth = 0.5
		tableView.dataSource = datasource
		tableView.delegate = self
		tableView.separatorInset = UIEdgeInsets.zero
		tableView.tableHeaderView = resultsListHeader
		shadowView.backgroundColor = UIColor.lightText
		shadowView.layer.shadowColor = UIColor.black.cgColor
		shadowView.layer.shadowOffset = CGSize.zero
		shadowView.layer.shadowOpacity = 1

		self.window?.addSubview(tableView)

		redrawSearchTableView()
	}

	// Re-set frames and theme colours
	fileprivate func redrawSearchTableView() {

		if let tableView = tableView {
			guard let frame = self.superview?.convert(self.frame, to: nil) else { return }

			tableView.estimatedRowHeight = 30
			if self.direction == .down {

				var tableHeight: CGFloat = 0
				if keyboardIsShowing, let keyboardHeight = keyboardFrame?.size.height {
					tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height - keyboardHeight))
				} else {
					tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height))
				}

				if maxResultsListHeight > 0 {
					tableHeight = min(tableHeight, CGFloat(maxResultsListHeight))
				}

				// Set a bottom margin of 10p
				if tableHeight < tableView.contentSize.height {
					tableHeight -= tableBottomMargin
				}

				var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
				tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
				tableViewFrame.origin.x += 2 + tableXOffset
				tableViewFrame.origin.y += frame.size.height + 2 + tableYOffset
				self.tableView?.frame.origin = tableViewFrame.origin // Avoid animating from (0, 0) when displaying at launch
				UIView.animate(withDuration: 0.2, animations: { [weak self] in
					self?.tableView?.frame = tableViewFrame
				})

				var shadowFrame = CGRect(x: 0, y: 0, width: frame.size.width - 6, height: 1)
				shadowFrame.origin = self.convert(shadowFrame.origin, to: nil)
				shadowFrame.origin.x += 3
				shadowFrame.origin.y = tableView.frame.origin.y
				shadowView!.frame = shadowFrame
			} else {
				let tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - 30))
				UIView.animate(withDuration: 0.2, animations: { [weak self] in
					self?.tableView?.frame = CGRect(x: frame.origin.x + 2, y: (frame.origin.y - tableHeight), width: frame.size.width - 4, height: tableHeight)
					self?.shadowView?.frame = CGRect(x: frame.origin.x + 3, y: (frame.origin.y + 3), width: frame.size.width - 6, height: 1)
				})
			}

			superview?.bringSubviewToFront(tableView)
			superview?.bringSubviewToFront(shadowView!)

			if self.isFirstResponder {
				superview?.bringSubviewToFront(self)
			}

			tableView.layer.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
			tableView.layer.cornerRadius = tableCornerRadius
			tableView.separatorColor = .clear
			tableView.backgroundColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.6)

			tableView.reloadData()

		}
	}

	fileprivate func filter(_ property: KeyPath<Model, String>, value: String) -> NSPredicate {
		switch filterOperator {
			case .some(.contains):
				return property ⊂ value
			case .some(.equal):
				return property == value
			default: return NSPredicate()
		}
	}
}
