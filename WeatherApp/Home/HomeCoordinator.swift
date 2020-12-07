//
//  HomeCoordinator.swift
//  WeatherApp
//
//  Created by dludlow7 on 30/04/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator]? { get set }
    var navigationController: UINavigationController { get }
}

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?
    var navigationController: UINavigationController
    var navigationControllerDelegate: UINavigationControllerDelegate?

    private var defaults: Defaults
    private var homeFactory: HomeFactory

    init(navigationController: UINavigationController, defaults: Defaults, homeFactory: HomeFactory) {
        self.navigationController = navigationController
        self.defaults = defaults
        self.homeFactory = homeFactory
        navigationControllerDelegate = NavigationTransitionDelegate()
        navigationController.delegate = navigationControllerDelegate
    }

    func start() {
        if defaults.get(.hasSeenIntro) == true {
            showHomeScreen()
        } else {
            defaults.set(true, forKey: .hasSeenIntro)
            startIntroFlow()
        }
    }

    private func startIntroFlow() {
        let introViewController = IntroViewController()
        introViewController.coordinatorDelegate = self
        navigationController.pushViewController(introViewController, animated: true)
    }
}

extension HomeCoordinator: IntroViewControllerDelegate {
    
    func showHomeScreen() {
        let homeViewController = homeFactory.getHomeViewController(homeViewModelDelegate: self)
        navigationController.pushViewController(homeViewController, animated: true)
    }
}

extension HomeCoordinator: SearchViewControllerDelegate {
    func didTapClose() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

extension HomeCoordinator: HomeViewModelDelegate {
    func startSearchFlow(delegate: LocationSelectionDelegate?) {
        let suggestionsAPI = SuggestionsAPI()
        let suggestionsService = SuggestionsService(suggestionsAPI: suggestionsAPI)
        let viewModel = SearchViewModel(suggestionsService: suggestionsService)
        let searchViewController = SearchViewController(viewModel: viewModel)
        viewModel.selectionDelegate = delegate
        searchViewController.coordinatorDelegate = self
        navigationController.present(searchViewController, animated: true)
    }

    func startMenuFlow() {
        let vc = MenuViewController()
        navigationController.present(vc, animated: true, completion: nil)
    }
}

