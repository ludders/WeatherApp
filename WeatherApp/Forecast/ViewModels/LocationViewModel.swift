//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 02/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

typealias UpdateForecastCompletion = Result<Bool, NetworkingError>

class LocationViewModel {
    private(set) var locationModelObs: Observable<LocationModel>
    var selectedDayIndexObs = Observable<Int>(0)
    var selectedDayObs = Observable<DailyForecast?>(nil)

    public init(model: LocationModel) {
        self.locationModelObs = Observable<LocationModel>(model)
        self.selectedDayIndexObs.bind { index in
            self.selectedDayObs.value = self.dailyForecast(for: index)
        }
    }

    var forecastDataItems: [[ForecastDataItem]] = [[]]

    public func updateForecast(onCompletion: @escaping (UpdateForecastCompletion) -> ()) {
        let service = WeatherService()
        service.getLocationForecast(for: locationModelObs.value.location) { result in
            switch result {
            case .success(let forecast):
                self.locationModelObs.value.forecast = forecast
                self.forecastDataItems = forecast.asDataItems
                self.selectedDayObs.value = self.dailyForecast(for: self.selectedDayIndexObs.value)
                onCompletion(.success(true))
            case .failure(let error):
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

    func addLocationTapped() {

    }
}

enum ForecastDataItem {
    case day(DailyForecast)
    case hourly(HourlyForecast)
}

//MARK: - DayCollectionView Cell ViewModels

protocol DayCollectionViewViewModel {
    var numberOfDayItems: Int { get }
    func viewModelForCellAt(index: Int) -> DayCellViewModel
}

extension LocationViewModel: DayCollectionViewViewModel {

    private var dailyForecasts: [DailyForecast]? {
        return locationModelObs.value.forecast?.dailyForecasts ?? nil
    }

    var numberOfDayItems: Int {
        return dailyForecasts?.count ?? 0
    }

    func viewModelForCellAt(index: Int) -> DayCellViewModel {
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
        let cellViewModel = DayCellViewModel(cellStyle: cellStyle,
                                             backgroundColor: Theme.Colours.bbcGrey,
                                             dayName: dailyForecast.time.formattedAs("EEE"),
                                             image: UIImage(systemName: dailyForecast.symbol ?? ""),
                                             maxTemp: dailyForecast.maxTemp?.asTemperatureString,
                                             minTemp: dailyForecast.minTemp?.asTemperatureString,
                                             isSelected: selectedDayIndexObs.value == index)
        return cellViewModel
    }
}

struct DayCellViewModel {
    var cellStyle: DayCellStyle
    var backgroundColor: UIColor
    var dayName: String
    var image: UIImage?
    var maxTemp: String?
    var minTemp: String?
    var isSelected: Bool
}

//MARK: - ForecastCollectionView Cell ViewModels

protocol ForecastCollectionViewViewModel {
    var numberOfForecastItems: Int { get }
    func viewModelForCellAt(index: Int) -> ForecastCellViewModel
}

extension LocationViewModel: ForecastCollectionViewViewModel {

    var numberOfForecastItems: Int {
        guard forecastDataItems.count > 1 else { return 0 }
        return forecastDataItems[selectedDayIndexObs.value].count
    }

    func viewModelForCellAt(index: Int) -> ForecastCellViewModel {
        let item = forecastDataItems[selectedDayIndexObs.value][index]

        switch item {
        case .day(let forecast):
            return DailyForecastCellViewModel(image: UIImage(systemName: forecast.symbol ?? ""),
                                            maxTemp: forecast.maxTemp?.asTemperatureString,
                                            minTemp: forecast.minTemp?.asTemperatureString,
                                            description: forecast.description?.localizedCapitalized,
                                            windSpeed: String(Int(forecast.windSpeed ?? 0)),
                                            windDegrees: forecast.windDeg ?? 0,
                                            showHoursIndicator: numberOfForecastItems > 1)

        case .hourly(let forecast):
            return HourlyForecastCellViewModel(time: forecast.formattedTime,
                                               nextDay: forecast.date.isAtMidnight ? forecast.date.formattedAs("EEE").localizedUppercase : nil,
                                               image: UIImage(systemName: forecast.symbol ?? ""),
                                               temp: forecast.temp?.asTemperatureString,
                                               cloudPercentage: String(forecast.clouds ?? 0) + "%",
                                               windSpeed: String(Int(forecast.windSpeed ?? 0)),
                                               windDegrees: forecast.windDeg ?? 0)
        }
    }
}

protocol ForecastCellViewModel { }

struct DailyForecastCellViewModel: ForecastCellViewModel {
    let image: UIImage?
    let maxTemp: String?
    let minTemp: String?
    let description: String?
    let windSpeed: String?
    let windDegrees: Int
    let showHoursIndicator: Bool
}

struct HourlyForecastCellViewModel: ForecastCellViewModel {
    let time: String
    let nextDay: String?
    let image: UIImage?
    let temp: String?
    let cloudPercentage: String
    let windSpeed: String?
    let windDegrees: Int
}
