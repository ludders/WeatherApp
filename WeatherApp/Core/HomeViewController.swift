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

//Will manage header view & act as parent for weather page view controller
class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel
    private let pageViewController: UIPageViewController
    private var containerView: UIView!
    private var headerView: HeaderView!

    init(viewModel: HomeViewModel, pageViewController: UIPageViewController) {
        self.viewModel = viewModel
        self.pageViewController = pageViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func loadView() {
        containerView = UIView(frame: UIScreen.main.bounds)
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupHeaderView()
    }

    private func setupHeaderView() {
        headerView = HeaderView()
        headerView.delegate = self
        headerView.tintColor = Theme.Colours.white
        containerView.addSubview(headerView)
        headerView.setupView()
    }

    private func setupPageViewController() {
        containerView.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
}

extension HomeViewController: HeaderViewDelegate {
    func didTapSearch() {
        viewModel.didTapSearch()
    }

    func didTapLocation() {
        viewModel.didTapLocation { [weak self] (disabled, error) in
            if disabled {
                self?.showLocationDisabledAlert()
            }
            if let error = error {
                self?.showErrorFetchingLocationAlert()
            }
        }
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
