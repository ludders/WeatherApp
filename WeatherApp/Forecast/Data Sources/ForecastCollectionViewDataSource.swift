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
        return viewModel.numberOfForecastItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cellViewModel: ForecastCellViewModel = viewModel.viewModelForCellAt(index: indexPath.item)

        if let cellViewModel = cellViewModel as? DailyForecastCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as? DailyForecastCollectionViewCell else {
                fatalError("Failed to dequeue DailyForecastCollectionViewCell")
            }
            cell.configure(with: cellViewModel)
            return cell

        } else if let cellViewModel = cellViewModel as? HourlyForecastCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as? HourlyForecastCollectionViewCell else {
                fatalError("Failed to dequeue HourlyForecastCollectionViewCell")
            }
            cell.configure(with: cellViewModel)
            return cell

        } else {
            fatalError("Unhandled implementation of ForecastCellViewModel returned for item at index: \(indexPath.item)")
        }
    }
}
