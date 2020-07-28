//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 02/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

typealias UpdateForecastCompletion = Result<Bool, NetworkingError>

class WeatherViewModel {
    private(set) var locationObs: Observable<LocationModel>
    var selectedDayIndexObs = Observable<Int>(0)
    var selectedDayObs = Observable<DailyForecast?>(nil)

    public init(model: LocationModel) {
        self.locationObs = Observable<LocationModel>(model)
        self.selectedDayIndexObs.bind { index in
            self.selectedDayObs.value = self.dailyForecast(for: index)
        }
    }

    var forecastDataItems: [[ForecastDataItem]] = [[]]

    public func updateForecast(onCompletion: @escaping (UpdateForecastCompletion) -> ()) {
        let service = WeatherService()
        service.getLocationForecast(for: locationObs.value) { result in
            switch result {
            case .success(let forecast):
                self.locationObs.value.forecast = forecast
                self.forecastDataItems = forecast.asDataItems
                self.selectedDayObs.value = self.dailyForecast(for: self.selectedDayIndexObs.value)
                onCompletion(.success(true))
            case .failure(let error):
                print(error)
                onCompletion(.failure(error))
            }
        }
    }

    private func dailyForecast(for index: Int) -> DailyForecast? {
        guard !forecastDataItems[selectedDayIndexObs.value].isEmpty else { return nil }
        switch forecastDataItems[selectedDayIndexObs.value][0] {
            case .day(let dailyForecast):
                return dailyForecast
            default:
                return nil
            }
    }
}

enum ForecastDataItem {
    case day(DailyForecast)
    case hourly(HourlyForecast)
}

//MARK: - Day Collection View Cell ViewModel

struct DayCollectionViewCellViewModel {
    var cellStyle: DayCellStyle
    var backgroundColor: UIColor
    var dayName: String
    var image: UIImage?
    var maxTemp: String?
    var minTemp: String?
    var isSelected: Bool
}

extension WeatherViewModel {

    var dailyForecasts: [DailyForecast]? {
        return locationObs.value.forecast?.dailyForecasts ?? nil
    }

    var numberOfDayItems: Int {
        return dailyForecasts?.count ?? 0
    }

    func viewModelForDayCollectionViewCellAt(at index: Int) -> DayCollectionViewCellViewModel {
        guard let dailyForecast = dailyForecasts?[index] else {
            fatalError("No Daily Forecast found for cell at this IndexPath!")
        }
        let cellStyle: DayCellStyle
        switch index {
        case 0:
            cellStyle = .frontCell
        case numberOfDayItems - 1:
            cellStyle = .endCell
        default:
            cellStyle = .middleCell
        }
        let cellViewModel = DayCollectionViewCellViewModel(cellStyle: cellStyle,
                                                           backgroundColor: Theme.Colours.bbcGrey,
                                                           dayName: dailyForecast.time.formattedAs("EEE"),
                                                           image: UIImage(systemName: dailyForecast.symbol ?? ""),
                                                           maxTemp: dailyForecast.maxTemp?.asTemperatureString,
                                                           minTemp: dailyForecast.minTemp?.asTemperatureString,
                                                           isSelected: selectedDayIndexObs.value == index)
        return cellViewModel
    }
}

//MARK: - Forecast Collection View Cell ViewModel

extension WeatherViewModel {

    var numberOfForecastItems: Int {
        return 0
    }

    func viewModelForForecastCollectionViewCellAt(at index: Int) -> ForecastCollectionViewCellViewModel {
        let cellViewModel = ForecastCollectionViewCellViewModel()
        return cellViewModel
    }

    struct ForecastCollectionViewCellViewModel {
    }
}

