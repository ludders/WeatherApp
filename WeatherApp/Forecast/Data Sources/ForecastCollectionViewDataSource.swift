//
//  ForecastCollectionViewDataSource.swift
//  WeatherApp
//
//  Created by dludlow7 on 12/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class ForecastCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    let viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.forecastDataItems.count > 1 {
            return viewModel.forecastDataItems[viewModel.selectedDayIndex.value].count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = viewModel.forecastDataItems[viewModel.selectedDayIndex.value][indexPath.item]
        switch item {
        case .day(let dailyForecast):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as? DailyForecastCollectionViewCell else {
                fatalError("Failed to dequeue DailyWeatherCollectionViewCell")
            }
            cell.configure(with: dailyForecast)
            return cell
        case .hourly(let hourlyForecast):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as? HourlyForecastCollectionViewCell else {
                fatalError("Failed to dequeue HourlyWeatherCollectionViewCell")
            }
            cell.configure(with: hourlyForecast)
            return cell
        }
    }
}
