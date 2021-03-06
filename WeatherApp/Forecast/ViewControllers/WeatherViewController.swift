//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 23/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class LocationViewController: UIViewController {

    var weatherView: WeatherView!
    lazy var errorView: WeatherErrorView = {
        let view = WeatherErrorView()
        view.tryAgainButton.onTouchUpInside { [weak self] in
            self?.refreshWeather()
        }
        return view
    }()
    private var viewModel: LocationViewModel

    let forecastCollectionViewController: UICollectionViewController
    let forecastCollectionViewDataSource: ForecastCollectionViewDataSource
    let forecastFlowLayout = UICollectionViewFlowLayout()
    let forecastCollectionViewDelegate = ForecastCollectionViewDelegate()

    let dayCollectionViewController: UICollectionViewController
    let dayCollectionViewDataSource: DayCollectionViewDataSource
    let dayFlowLayout = UICollectionViewFlowLayout()
    let dayCollectionViewDelegate: DayCollectionViewDelegate

    init(weatherViewModel: LocationViewModel,
         forecastCollectionViewDataSource: ForecastCollectionViewDataSource,
        dayCollectionViewDataSource: DayCollectionViewDataSource) {
        self.viewModel = weatherViewModel

        self.forecastCollectionViewController = UICollectionViewController(collectionViewLayout: forecastFlowLayout)
        self.forecastCollectionViewDataSource = forecastCollectionViewDataSource
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
        configureForecastCollectionView()
        configureDayCollectionView()
        setupBindings()
        addActions()
        weatherView.setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        refreshWeather()
    }

    private func setupBindings() {
        viewModel.locationModelObs.bindOnNext { locationModel in
            self.weatherView.configure(with: locationModel)
        }
        viewModel.selectedDayObs.bind { dailyForecast in
            guard let selectedDay = dailyForecast else { return }
            DispatchQueue.main.async {
                self.weatherView.headingView.subtitleLabel.text = selectedDay.subtitleDisplayText
                self.weatherView.headingView.sunriseLabel.text = selectedDay.sunriseDisplayText
                self.weatherView.headingView.sunsetLabel.text = selectedDay.sunsetDisplayText
                self.weatherView.forecastCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                self.weatherView.forecastCollectionView.reloadData()
            }
        }
    }

    private func addActions() {
        weatherView.headingView.refreshButton.onTouchUpInside { [weak self] in
            self?.refreshWeather()
        }
        weatherView.headingView.addLocationButton.onTouchUpInside { [weak self] in
            self?.viewModel.addLocationTapped()
        }
    }

    private func configureForecastCollectionView() {
        weatherView.forecastCollectionView.delegate = forecastCollectionViewDelegate
        weatherView.forecastCollectionView.dataSource = forecastCollectionViewDataSource
    }

    private func configureDayCollectionView() {
        weatherView.dayCollectionView.delegate = dayCollectionViewDelegate
        weatherView.dayCollectionView.dataSource = dayCollectionViewDataSource
    }

    private func refreshWeather() {
        view.displayLoadingView()
        viewModel.updateForecast { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.hideLoadingView()
            }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    guard self.view == self.weatherView else {
                        self.view = self.weatherView
                        return
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.view = self.errorView
                }
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

    var viewModel: LocationViewModel

    init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
    }

    //MARK: Delegate Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentSelectionIndexPath = IndexPath(item: viewModel.selectedDayIndexObs.value, section: 0)
        let newSelectionIndexPath = indexPath

        if newSelectionIndexPath != currentSelectionIndexPath {
            viewModel.selectedDayIndexObs.value = newSelectionIndexPath.item
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
