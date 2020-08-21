//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 01/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit
import SnapKit


protocol HomeViewControllerDelegate: AnyObject {
    func startSearchFlow()
    func startWeatherFlow(for location: Location, setAsDefault: Bool)
}

//Will manage header view & act as parent for weather page view controller
class HomeViewController: UIViewController {

    private let currentLocationProvider: CurrentLocationProvider
    private let pageViewController: UIPageViewController
    weak var coordinatorDelegate: HomeViewControllerDelegate?
    private var containerView: UIView!
    private var headerView: HeaderView!

    init(pageViewController: UIPageViewController, currentLocationProvider: CurrentLocationProvider) {
        self.pageViewController = pageViewController
        self.currentLocationProvider = currentLocationProvider
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
        coordinatorDelegate?.startSearchFlow()
    }

    func didTapLocation() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocationProvider.getCurrentLocation { [weak self] result in
                switch result {
                case .success(let currentLocation):
                    self?.coordinatorDelegate?.startWeatherFlow(for: currentLocation, setAsDefault: false)
                case .failure(let error):
                    print(error)
                }
            }
        case .notDetermined:
            currentLocationProvider.requestWhenInUseAuthorisation()
        case .denied, .restricted:
            let locationTitle = NSLocalizedString("Location Disabled", comment: "Location Disabled")
            let locationMessage = NSLocalizedString("Please enable location services to use this feature", comment: "Please enable location services to use this feature")
            let settingsTitle = NSLocalizedString("Go To Settings", comment: "Go To Settings")
            let cancelTitle = NSLocalizedString("Cancel", comment: "Cancel")

            let ac = UIAlertController(title: locationTitle, message: locationMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: settingsTitle, style: .default, handler: goToSettings))
            ac.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        @unknown default:
            fatalError("Unhandled CLAuthorizationStatus: \(status)")
        }
    }

    private func goToSettings(_: UIAlertAction) {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
