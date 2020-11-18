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
    private(set) var locations: [Location] //TODO: Remove this now that we have the locationRepository here?
    private var locationRepository: LocationRepository
    private(set) var currentPageIndex: Int = 0 //Only updated once the transition to another VC is completed

    init(locations: [Location],
         weatherService: WeatherService,
         locationRepository: LocationRepository) {
        self.locations = locations
        self.weatherService = weatherService
        self.locationRepository = locationRepository
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
        locations.insert(location, at: 0)
        currentPageIndex += 1
    }

    //TODO: Loads of dependencies in here now - find a way to inject?
    private func createViewControllerForLocation(atIndex index: Int) -> LocationViewController? {
        guard (0...locations.endIndex-1).contains(index) else {
            return nil
        }
        let model = LocationModel(location: locations[index])
        let defaults = Defaults()
        let viewModel = LocationViewModel(model: model,
                                          weatherService: weatherService,
                                          locationRepository: locationRepository,
                                          defaults: defaults)
        viewModel.delegate = self
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

extension LocationPageViewControllerDataSource: LocationViewModelDelegate {

    func didSave(location: Location) {
        guard let index = locations.firstIndex(where: { $0 == location }) else { return }
        locations[index] = location
    }
}
