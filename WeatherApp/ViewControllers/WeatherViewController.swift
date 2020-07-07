//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 23/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {

    var weatherView: WeatherView!
    var viewModel: WeatherViewModel

    let forecastCollectionViewController: UICollectionViewController
    let forecastCollectionViewDataSource: ForecastCollectionViewDataSource
    let forecastFlowLayout = UICollectionViewFlowLayout()
    let forecastCollectionViewDelegate = ForecastCollectionViewDelegate()

    let dayCollectionViewController: UICollectionViewController
    let dayCollectionViewDataSource: DayCollectionViewDataSource
    let dayFlowLayout = UICollectionViewFlowLayout()
    let dayCollectionViewDelegate: DayCollectionViewDelegate

    init(weatherViewModel: WeatherViewModel,
         forecastCollectionViewDataSource: ForecastCollectionViewDataSource,
        dayCollectionViewDataSource: DayCollectionViewDataSource) {
        self.viewModel = weatherViewModel

        self.forecastCollectionViewController = UICollectionViewController(collectionViewLayout: forecastFlowLayout)
        self.forecastCollectionViewDataSource = forecastCollectionViewDataSource
        //TODO: Add forecast collection view delegate
        self.dayCollectionViewController = UICollectionViewController(collectionViewLayout: dayFlowLayout)
        self.dayCollectionViewDataSource = dayCollectionViewDataSource
        self.dayCollectionViewDelegate = DayCollectionViewDelegate(viewModel: weatherViewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        weatherView = WeatherView(forecastFlowLayout: forecastFlowLayout, dayFlowLayout: dayFlowLayout)
        weatherView.backgroundColor = Theme.Colours.black
        view = weatherView
    }

    override func viewDidLoad() {
        addChildViewControllers()
        weatherView.setupView()
        configureForecastCollectionView()
        configureDayCollectionView()
        setupBindings()
        weatherView.headingView.refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)

    }

    override func viewDidAppear(_ animated: Bool) {
        view.displayLoadingView()
        viewModel.updateForecast { result in
            DispatchQueue.main.async {
                self.view.hideLoadingView()
            }
        }
    }

    private func setupBindings() {
        viewModel.locationForecast.bindOnNext { locationForecast in
            self.weatherView.configure(with: locationForecast)
        }
        viewModel.selectedDayObs.bind { dailyForecast in
            guard let selectedDay = dailyForecast else { return }
            DispatchQueue.main.async {
                //TODO update header view subtitle/sunrise/sunset with dailyForecasts[selectedIndex][0] etc....
                self.weatherView.headingView.subtitleLabel.text = "Missing"
                self.weatherView.headingView.sunriseLabel.text = selectedDay.sunriseDisplayText
                self.weatherView.headingView.sunsetLabel.text = selectedDay.sunriseDisplayText
                self.weatherView.forecastCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                self.weatherView.forecastCollectionView.reloadData()
            }
        }
    }

    private func addChildViewControllers() {
        addChild(forecastCollectionViewController)
        forecastCollectionViewController.collectionView = weatherView.forecastCollectionView
        forecastCollectionViewController.didMove(toParent: self)

        addChild(dayCollectionViewController)
        dayCollectionViewController.collectionView = weatherView.dayCollectionView
        dayCollectionViewController.didMove(toParent: self)
    }

    private func configureForecastCollectionView() {
        weatherView.forecastCollectionView.delegate = forecastCollectionViewDelegate
        weatherView.forecastCollectionView.dataSource = forecastCollectionViewDataSource
    }

    private func configureDayCollectionView() {
        weatherView.dayCollectionView.delegate = dayCollectionViewDelegate
        weatherView.dayCollectionView.dataSource = dayCollectionViewDataSource
    }

    @objc func didTapRefresh() {
        view.displayLoadingView()
        viewModel.updateForecast { result in
            DispatchQueue.main.async {
                self.view.hideLoadingView()
            }
        }
    }
}

// MARK: Day Collection View Delegate + Flow Delegate
class ForecastCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return collectionView.visibleSize
        } else {
            let width = collectionView.visibleSize.width/5
            let height = collectionView.visibleSize.height
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: Day Collection View Delegate + Flow Delegate
class DayCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }

    //MARK: Delegate Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentSelectionIndexPath = IndexPath(item: viewModel.selectedDayIndex.value, section: 0)
        let newSelectionIndexPath = indexPath

        if newSelectionIndexPath != currentSelectionIndexPath {
            viewModel.selectedDayIndex.value = newSelectionIndexPath.item
            DispatchQueue.main.async {
                collectionView.reloadItems(at: [currentSelectionIndexPath, newSelectionIndexPath])
            }
        }
    }

    //MARK: Delegate Flow Layout Functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
