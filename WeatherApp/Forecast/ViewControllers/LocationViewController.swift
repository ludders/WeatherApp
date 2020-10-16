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
    private var locationView: LocationView!
    private lazy var errorView: LocationErrorView = {
        let view = LocationErrorView()
        view.tryAgainButton.onTouchUpInside { [weak self] in
            self?.viewModel.getForecast()
        }
        return view
    }()
    private var viewModel: LocationViewModel

    private let forecastCollectionViewDataSource: ForecastCollectionViewDataSource
    private let forecastFlowLayout = UICollectionViewFlowLayout()
    private let forecastCollectionViewDelegate = ForecastCollectionViewDelegate()

    private let dayCollectionViewDataSource: DayCollectionViewDataSource
    private let dayFlowLayout = UICollectionViewFlowLayout()
    private let dayCollectionViewDelegate: DayCollectionViewDelegate

    init(viewModel: LocationViewModel,
         forecastCollectionViewDataSource: ForecastCollectionViewDataSource,
        dayCollectionViewDataSource: DayCollectionViewDataSource) {
        self.viewModel = viewModel

        self.forecastCollectionViewDataSource = forecastCollectionViewDataSource
        self.dayCollectionViewDataSource = dayCollectionViewDataSource
        self.dayCollectionViewDelegate = DayCollectionViewDelegate(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        locationView = LocationView(forecastFlowLayout: forecastFlowLayout, dayFlowLayout: dayFlowLayout)
        locationView.backgroundColor = Theme.Colours.black
        view = locationView
    }

    override func viewDidLoad() {
        configureForecastCollectionView()
        configureDayCollectionView()
        setupBindings()
        addActions()
        locationView.setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.getForecast()
    }

    private func setupBindings() {
        locationView.titleLabel.text = viewModel.displayTitle
        viewModel.locationViewStateObs.bind { state in
            self.locationView.configure(for: state)
        }

        viewModel.selectedDayObs.bind { dailyForecast in
            guard let selectedDay = dailyForecast else { return }
            DispatchQueue.main.async {
                //TODO: Move this out of here into the view?
                self.locationView.subtitleLabel.text = selectedDay.subtitleDisplayText
                self.locationView.sunriseLabel.text = selectedDay.sunriseDisplayText
                self.locationView.sunsetLabel.text = selectedDay.sunsetDisplayText
                self.locationView.forecastCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                self.locationView.forecastCollectionView.reloadData()
            }
        }
    }

    private func addActions() {
        locationView.addLocationButton.onTouchUpInside { [weak self] in
            self?.viewModel.addLocationTapped()
        }
    }

    private func configureForecastCollectionView() {
        locationView.forecastCollectionView.delegate = forecastCollectionViewDelegate
        locationView.forecastCollectionView.dataSource = forecastCollectionViewDataSource
    }

    private func configureDayCollectionView() {
        locationView.dayCollectionView.delegate = dayCollectionViewDelegate
        locationView.dayCollectionView.dataSource = dayCollectionViewDataSource
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
