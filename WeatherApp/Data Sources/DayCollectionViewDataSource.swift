//
//  DayCollectionViewDataSource.swift
//  WeatherApp
//
//  Created by dludlow7 on 24/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class DayCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    let viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.locationForecast.value.dailyForecasts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCollectionViewCell", for: indexPath) as? DayCollectionViewCell else {
            fatalError("Failed to dequeue DayCollectionViewCell")
        }

        guard let dailyForecasts = viewModel.locationForecast.value.dailyForecasts else {
            fatalError("Attempted to dequeue DayCollectionViewCell with no model present")
        }

        var style: DayCellStyle {
            switch indexPath.row {
            case 0:
                return .frontCell
            case dailyForecasts.count - 1:
                return .endCell
            default:
                return .middleCell
            }
        }

        cell.isSelected = viewModel.selectedDayIndex == indexPath.item
        cell.configure(with: dailyForecasts[indexPath.row], style: style)
        return cell
    }
}
