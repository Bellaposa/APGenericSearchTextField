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

/// Generic Search Text Field
open class GenericSearchTextField<Model>: UITextField, UITableViewDelegate {

	/// datasource
	fileprivate var datasource: TableViewDataSource<Model>?
	/// identifier
	fileprivate let identifier: String = "APGenericSearchTextFieldCell"
	/// tableView
	fileprivate var tableView: UITableView?
	/// shadow View
	fileprivate var shadowView: UIView?
	/// result list header
	fileprivate var resultsListHeader: UIView?
	/// direction to .down
	fileprivate var direction: Direction = .down
	/// keyboard frame
	fileprivate var keyboardFrame: CGRect?

	/// Value for table view customisation
	open var tableXOffset: CGFloat = 0.0
	open var tableYOffset: CGFloat = 0.0
	open var tableCornerRadius: CGFloat = 2.0
	open var tableBottomMargin: CGFloat = 10.0
	open var keyboardIsShowing = false
	open var maxResultsListHeight = 0
	open var minCharactersNumberToStartFiltering: Int = 0

	/// Operator used for filter property
	open var filterOperator: FilterOperator?
	/// Property to filter
	open var propertyToFilter: KeyPath<Model, String>?
	/// Callback for selection
	open var itemSelectionHandler: ItemHandler?
	open var stoppedTypingHandler: StoppedTypingHandler?
	open var singleItemHandler: SingleItemHandler?
	open var cellConfigurator: CellConfigurator?

	open var model: [Model] = [] {
		didSet {
			guard cellConfigurator != nil else {
				fatalError(ErrorMessage.missingCellConfigurator.description)
			}
			self.datasource = TableViewDataSource(models: model, reuseIdentifier: identifier, cellConfigurator: cellConfigurator!)
		}
	}

	/// Deinit
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	/// Init
	public init(model: [Model], frame: CGRect, cellConfigurator: @escaping (CellConfigurator)) {
		self.datasource = TableViewDataSource(models: model, reuseIdentifier: identifier, cellConfigurator: cellConfigurator)
		self.model = model
		self.cellConfigurator = cellConfigurator
		super.init(frame: frame)
		self.buildSearchTableView()
	}
	/// Required init
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	/// Layout subviews
	override open func layoutSubviews() {
		super.layoutSubviews()
		buildSearchTableView()
	}
	/// willMove
	override open func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		/// adding textField delegates
		self.addTarget(self, action: #selector(GenericSearchTextField.textFieldDidChange), for: .editingChanged)
		self.addTarget(self, action: #selector(GenericSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
		self.addTarget(self, action: #selector(GenericSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
		self.addTarget(self, action: #selector(GenericSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)

		/// Notification for keyboard
		NotificationCenter.default.addObserver(self, selector: #selector(GenericSearchTextField.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(GenericSearchTextField.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(GenericSearchTextField.keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)

	}

	/// Did Change
	@objc func textFieldDidChange() {

		if text?.isEmpty == true {
			clearResults()
		}

		buildSearchTableView()
		/// Check if properties are not null
		guard let property = propertyToFilter else {
			fatalError(ErrorMessage.missingPropertyToFilter.description)
		}

		guard filterOperator != nil else {
			fatalError(ErrorMessage.missingFilterOperator.description)
		}

		guard text!.count >= minCharactersNumberToStartFiltering else {
			return
		}
		/// create predicate - search - and then reload
		let predicate = filter(property, value: text!)
		datasource?.search(query: predicate)
		guard let count = datasource?.searchResults.count, count > 0 else {
			clearResults()
			return
		}

		tableView?.reloadData()
	}
	/// Did Begin Editing
	@objc func textFieldDidBeginEditing() {
		clearResults()
	}
	/// Did End Editing
	@objc func textFieldDidEndEditing() {
		clearResults()
		tableView?.reloadData()
	}
	/// Did End Editing on Exit
	@objc func textFieldDidEndEditingOnExit() {
		if let itemHandler = itemSelectionHandler {
			itemHandler(datasource?.searchResults ?? [])
		}
	}
	/// Keyboard Will Show Notification
	@objc func keyboardWillShow(_ notification: Notification) {
		if !keyboardIsShowing && isEditing {
			keyboardIsShowing = true
			keyboardFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
			drawTableResult()
		}
	}
	/// Keyboard Will Hide Notification
	@objc func keyboardWillHide(_ notification: Notification) {
		if keyboardIsShowing {
			keyboardIsShowing = false
			direction = .down
			redrawSearchTableView()
		}
	}
	/// Keyboard Did Change Frame
	@objc func keyboardDidChangeFrame(_ notification: Notification) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			self?.keyboardFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
			self?.drawTableResult()
		}
	}
	/// TableView DidSelect Row At IndexPath
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let singleItem = singleItemHandler, let item = datasource?.getModelAt(indexPath) {
			singleItem(item)
			clearResults()
		}
	}
}

extension GenericSearchTextField {
	/// Create the filter table and shadow view
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

	/// Re-set frames
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

				/// Set a bottom margin
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
	///
	/// - Parameters:
	///   - property: KeyPath Value
	///   - value: value you want to search
	/// - Returns: NSPredicate
	fileprivate func filter(_ property: KeyPath<Model, String>, value: String) -> NSPredicate {
		switch filterOperator {
			case .some(.contains):
				return property ⊂ value
			case .some(.equal):
				return property == value
			default: return NSPredicate()
		}
	}

	/// Clear all results
	fileprivate func clearResults() {
		datasource?.searchResults.removeAll()
		tableView?.reloadData()
		tableView?.removeFromSuperview()
	}


	/// Draw table result
	fileprivate func drawTableResult() {
		guard let frame = self.superview?.convert(self.frame, to: UIApplication.shared.keyWindow) else { return }
		if let keyboardFrame = keyboardFrame {
			var newFrame = frame
			newFrame.size.height += 20

			if keyboardFrame.intersects(newFrame) {
				direction = .up
			} else {
				direction = .down
			}

			redrawSearchTableView()
		} else {
			if self.center.y + 20 > UIApplication.shared.keyWindow!.frame.size.height {
				direction = .up
			} else {
				direction = .down
			}
		}
	}
}
extension GenericSearchTextField: TextFieldHelperProtocol {}
