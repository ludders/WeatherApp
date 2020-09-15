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
    private var currentIndex: Int = 0

    init(locations: [Location]) {
        self.locations = locations
    }

    func initialPageViewController(startIndex: Int = 0) -> LocationViewController? {
        return createViewControllerForLocation(atIndex: startIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        createViewControllerForLocation(atIndex: currentIndex - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        createViewControllerForLocation(atIndex: currentIndex + 1)
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
        return viewController
    }
}
