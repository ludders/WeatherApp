//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 01/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private var headerView: HeaderView!
    private let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    private let viewModel: HomeViewModel
    private var locationStore: LocationStore
    private var locationPageViewControllerDataSource: LocationPageViewControllerDataSource

    init(viewModel: HomeViewModel,
         locationStore: LocationStore,
         locationPageViewControllerDataSource: LocationPageViewControllerDataSource) {
        self.viewModel = viewModel
        self.locationStore = locationStore
        self.locationPageViewControllerDataSource = locationPageViewControllerDataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Colours.black
        setupPageViewController()
        setupHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        pageViewController.additionalSafeAreaInsets = UIEdgeInsets(top: headerView.frame.height, left: 0, bottom: 0, right: 0)
    }

    private func setupPageViewController() {
        addPageViewControllerAsChild()
        pageViewController.dataSource = locationPageViewControllerDataSource
        pageViewController.delegate = locationPageViewControllerDataSource
        displayFirstPage()
    }

    private func addPageViewControllerAsChild() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        pageViewController.didMove(toParent: self)
    }

    private func setupHeaderView() {
        headerView = HeaderView()
        headerView.delegate = self
        view.addSubview(headerView)
        headerView.setupView()
    }

    private func displayFirstPage() {
        guard let locationViewController = locationPageViewControllerDataSource.getFirstPageViewController() else { return }
        pageViewController.setViewControllers([locationViewController], direction: .forward, animated: false, completion: nil)
    }

    private func displayNewLocation(location: Location) {
        locationStore.add(location)
        locationPageViewControllerDataSource.addNewPageAtTop(for: location)
        displayFirstPage()
    }
}

extension HomeViewController: LocationSelectionDelegate {
    func didSelect(_ location: Location) {
        displayNewLocation(location: location)
    }
}

extension HomeViewController: HeaderViewDelegate {
    func didTapSearch() {
        viewModel.didTapSearch(selectionDelegate: self)
    }

    func didTapLocation() {
        viewModel.didTapLocation { location in
            self.displayNewLocation(location: location)
        } onDisabled: {
            self.showLocationDisabledAlert()
        } onError: { error in
            self.showErrorFetchingLocationAlert()
        }
    }

    //For debugging only
    func didTapImage() {
        viewModel.didTapImage()
    }

    private func showLocationDisabledAlert() {
        let locationTitle = NSLocalizedString("Location Disabled", comment: "Location Disabled")
        let locationMessage = NSLocalizedString("Please enable location services to use this feature", comment: "Please enable location services to use this feature")
        let settingsButtonTitle = NSLocalizedString("Go To Settings", comment: "Go To Settings")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel")

        let ac = UIAlertController(title: locationTitle, message: locationMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: settingsButtonTitle, style: .default, handler: goToSettings))
        ac.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }

    private func showErrorFetchingLocationAlert() {
        let title = NSLocalizedString("Error", comment: "Error")
        let message = NSLocalizedString("Error fetching current location, please try again", comment: "Error fetching current location, please try again")
        let tryAgainButtonTitle = NSLocalizedString("Try Again", comment: "Try Again")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel")

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: tryAgainButtonTitle, style: .default, handler: { [weak self] _ in
            self?.didTapLocation()
        }))
        ac.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil))
    }

    private func goToSettings(_: UIAlertAction) {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
