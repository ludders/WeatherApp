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
    private var weatherService: WeatherService
    private var locationStore: LocationStore

    private var sortedLocations: [Location] {
        return locationStore.locations.sorted { (location1, location2) in
            // Sort Unsaved above Saved, then sort by most recently created
            if location1.saved == location2.saved {
                return location1.dateCreated > location2.dateCreated
            } else {
                return location1.saved == false && location2.saved == true
            }
        }
    }

    private(set) var currentPageIndex: Int = 0 //Only updated once the transition to another VC is completed

    init(weatherService: WeatherService,
         locationStore: LocationStore) {
        self.weatherService = weatherService
        self.locationStore = locationStore
    }

    func getFirstPageViewController(startIndex: Int = 0) -> UIViewController? {
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
        currentPageIndex += 1
    }

    //TODO: Loads of dependencies in here now - find a way to inject?
    private func createViewControllerForLocation(atIndex index: Int) -> LocationViewController? {
        guard (0...sortedLocations.endIndex-1).contains(index) else {
            return nil
        }
        let model = LocationModel(location: sortedLocations[index])
        let defaults = Defaults()
        let viewModel = LocationViewModel(model: model,
                                          weatherService: weatherService,
                                          locationStore: locationStore,
                                          defaults: defaults)
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
