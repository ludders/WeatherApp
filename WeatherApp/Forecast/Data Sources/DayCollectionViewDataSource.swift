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
        return viewModel.numberOfDayItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCollectionViewCell", for: indexPath) as? DayCollectionViewCell else {
            fatalError("Failed to dequeue DayCollectionViewCell")
        }

        let cellViewModel = viewModel.viewModelForDayCollectionViewCellAt(at: indexPath.item)
        cell.configure(with: cellViewModel)
        return cell
    }
}
