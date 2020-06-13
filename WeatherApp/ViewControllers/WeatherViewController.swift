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
    var weatherViewModel: WeatherViewModel
    let forecastCollectionViewController: UICollectionViewController
    let forecastCollectionViewDataSource: ForecastCollectionViewDataSource
    let forecastCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    init(weatherViewModel: WeatherViewModel,
         forecastCollectionViewDataSource: ForecastCollectionViewDataSource) {
        self.weatherViewModel = weatherViewModel
        self.forecastCollectionViewController = UICollectionViewController(collectionViewLayout: forecastCollectionViewFlowLayout)
        self.forecastCollectionViewDataSource = forecastCollectionViewDataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        weatherView = WeatherView(flowLayout: forecastCollectionViewFlowLayout)
        weatherView.backgroundColor = Theme.Colours.black
        view = weatherView
    }

    override func viewDidLoad() {
        addChildViewControllers()
        weatherView.setupView()
        configureCollectionView()
        weatherViewModel.updateForecast()
        weatherViewModel.locationForecast.bind { locationForecast in
            self.weatherView.configure(with: locationForecast)
        }
        weatherView.headingView.refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
    }

    private func addChildViewControllers() {
        addChild(forecastCollectionViewController)
        forecastCollectionViewController.collectionView = weatherView.forecastCollectionView
        forecastCollectionViewController.didMove(toParent: self)
    }

    private func configureCollectionView() {
        weatherView.forecastCollectionView.delegate = self
        weatherView.forecastCollectionView.dataSource = forecastCollectionViewDataSource
    }

    @objc func didTapRefresh() {
        weatherViewModel.updateForecast()
    }
}
// MARK: Forecast Collection View Delegate Functions

extension WeatherViewController: UICollectionViewDelegate {

}

// MARK: Forecast Collection View Delegate Flow Layout Functions

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            //Day/Current cell
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
