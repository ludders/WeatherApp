//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 01/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol SearchViewControllerDelegate: AnyObject {
    func didTapClose()
}

class SearchViewController: UIViewController {

    private let viewModel: SearchViewModel

    private let titleLabel = UILabel()
    private var closeButton = UIButton()
    private let searchIconView = UIImageView()
    private let clearIconButton = UIButton()
    private let textField = PaddableTextField()

    private let tableView = UITableView()
    private let tableViewController = UITableViewController()

    weak var coordinatorDelegate: SearchViewControllerDelegate?

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("No storyboards!")
    }

    override func viewDidLoad() {
        setupViews()
        setupActions()
        setupTableView()
        setupConstraints()
        viewModel.searchModel.bind { suggestions in
            guard suggestions != nil else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupViews() {
        view.backgroundColor = Theme.Colours.blackTranslucent

        titleLabel.font = Theme.Fonts.BBC.largeTitle30
        titleLabel.text = NSLocalizedString("Location Search", comment: "Location Search")
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = Theme.Colours.white
        titleLabel.textAlignment = .left
        titleLabel.baselineAdjustment = .alignCenters
        view.addSubview(titleLabel)

        closeButton = UIButton(type: .system)
        closeButton.setTitle(NSLocalizedString("Close", comment: "Close"), for: .normal)
        closeButton.tintColor = Theme.Colours.silver
        view.addSubview(closeButton)

        textField.delegate = self
        textField.layer.cornerRadius = 5
        textField.backgroundColor = Theme.Colours.bbcGrey
        textField.textColor = Theme.Colours.white
        textField.overlayViewsEdgeInsets = UIEdgeInsets(top: 7.5, left: 5, bottom: 5, right: 5)
        textField.font = Theme.Fonts.BBC.body
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Enter a location", comment: "Enter a location"),
                                                             attributes: [NSAttributedString.Key.foregroundColor: Theme.Colours.silver])

        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        searchIconView.tintColor = Theme.Colours.white
        textField.leftView = searchIconView
        textField.leftViewMode = .always

        clearIconButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        clearIconButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        clearIconButton.imageView?.contentMode = .scaleAspectFit
        clearIconButton.contentVerticalAlignment = .fill
        clearIconButton.contentHorizontalAlignment = .fill
        clearIconButton.tintColor = Theme.Colours.white
        textField.rightView = clearIconButton
        textField.rightViewMode = .whileEditing
        view.addSubview(textField)

        tableView.backgroundColor = Theme.Colours.black
        view.addSubview(tableView)
    }

    func setupActions() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        clearIconButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionCell")
    }

    func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(closeButton.snp.leading).offset(-10)
        }

        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalTo(textField)
            make.bottom.equalToSuperview()
        }
    }

    @objc func didTapClose() {
        coordinatorDelegate?.didTapClose()
    }

    @objc func didTapClear() {
        textField.text = ""
        viewModel.clearSuggestions()
    }
}

class PaddableTextField: UITextField {

    public var overlayViewsEdgeInsets: UIEdgeInsets = .zero

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewFrame = self.leftView!.frame
        return CGRect(x: 0 + overlayViewsEdgeInsets.left, y: overlayViewsEdgeInsets.top, width: leftViewFrame.width, height: leftViewFrame.height)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightViewFrame = self.rightView!.frame
        return CGRect(x: self.frame.width - rightViewFrame.width - overlayViewsEdgeInsets.right, y: overlayViewsEdgeInsets.top, width: rightViewFrame.width, height: rightViewFrame.height)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: overlayViewsEdgeInsets))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.inset(by: overlayViewsEdgeInsets))
    }
}

//MARK - Text Field Delegate Functions

extension SearchViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
            let textRange = Range(range, in: text) else { return true }
        let searchText = text.replacingCharacters(in: textRange, with: string)
        viewModel.searchTextDidChange(to: searchText)
        return true
    }
}

// MARK - Table View Delegate

extension SearchViewController: UITableViewDelegate {}

//MARK - Table View Data Source

extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let suggestionsModel = viewModel.searchModel.value else {
            return 0
        }
        switch suggestionsModel.state {
        case .hasLoaded:
            return viewModel.numberOfSuggestions
        case .isLoading, .hasError(_):
            return 1
        }
    }

//    Use UITableViewHeaderFooterView objects to define the appearance of your headers and footers.
//    Register your UITableViewHeaderFooterView objects with your table view.
//    Implement the tableView(_:viewForHeaderInSection:) and tableView(_:viewForFooterInSection:) methods in your table view delegate object to create and configure your views.

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        guard let searchModel = viewModel.searchModel.value else {
            fatalError("No suggestion found at given IndexPath")
        }

        cell.contentView.backgroundColor = Theme.Colours.black
        cell.textLabel?.textColor = Theme.Colours.white

        switch searchModel.state {
        case .hasLoaded:
            let suggestion = searchModel.suggestions[indexPath.row]
            cell.textLabel?.text = suggestion.displayName
            return cell
        case .hasError(_):
            cell.textLabel?.text = NSLocalizedString("Error fetching results, please try again", comment: "Error fetching results, please try again")
            cell.textLabel?.textColor = Theme.Colours.bbcRed
            break
        case .isLoading:
            cell.textLabel?.text = NSLocalizedString("Loading...", comment: "Loading...")
            cell.textLabel?.textColor = Theme.Colours.silver
        }
        return cell
    }
}
