//
//  LocationPageViewControllerDataSource.swift
//  WeatherApp
//
//  Created by dludlow7 on 14/09/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class LocationPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    private var locations: [Location]
    private(set) var currentPageIndex: Int = 0 //Only updated once the transition to another VC is completed

    init(locations: [Location]) {
        self.locations = locations
    }

    func getFirstPageViewController(startIndex: Int = 0) -> LocationViewController? {
        //TODO: Return a 'no locations' view controller when this is nil
        currentPageIndex = startIndex
        return createViewControllerForLocation(atIndex: startIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return createViewControllerForLocation(atIndex: currentPageIndex - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return createViewControllerForLocation(atIndex: currentPageIndex + 1)
    }

    func addNewPageAtTop(for location: Location) {
        locations.insert(location, at: 0)
        currentPageIndex += 1
    }

    //TODO: Loads of dependencies in here now - find a way to inject?
    private func createViewControllerForLocation(atIndex index: Int) -> LocationViewController? {
        guard (0...locations.endIndex-1).contains(index) else {
            return nil
        }
        let model = LocationModel(location: locations[index])
        let viewModel = LocationViewModel(model: model)
        let dayCollectionViewDataSource = DayCollectionViewDataSource(viewModel: viewModel)
        let forecastCollectionViewDataSource = ForecastCollectionViewDataSource(viewModel: viewModel)
        let viewController = LocationViewController(viewModel: viewModel,
                                                    forecastCollectionViewDataSource: forecastCollectionViewDataSource,
                                                    dayCollectionViewDataSource: dayCollectionViewDataSource)
        viewController.view.tag = index
        return viewController
    }
}

extension LocationPageViewControllerDataSource: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let newIndex = pageViewController.viewControllers?.first?.view.tag else { return }
        currentPageIndex = newIndex
    }
}