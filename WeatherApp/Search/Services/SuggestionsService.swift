//
//  AutocompleteService.swift
//  WeatherApp
//
//  Created by dludlow7 on 07/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import CoreLocation
import Foundation

typealias SuggestionsCompletion = Result<[Suggestion], NetworkingError>

class SuggestionsService {

    let suggestionsAPI: SuggestionsAPI

    init(suggestionsAPI: SuggestionsAPI) {
        self.suggestionsAPI = suggestionsAPI
    }

    func getSuggestions(searchString: String, completion: @escaping (SuggestionsCompletion) -> ()) {
        suggestionsAPI.getSuggestionsResponse(for: searchString) { result in
            switch result {
            case .success(let response):
                let suggestions = response.compactMap { suggestionResult -> Suggestion? in
                    guard let latitude = Double(suggestionResult.lat),
                        let longitude = Double(suggestionResult.lon) else { return nil }

                    return Suggestion(displayName: suggestionResult.displayName,
                                      coordinates: CLLocationCoordinate2D(latitude: latitude,
                                                                          longitude: longitude))
                }
                completion(.success(suggestions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
