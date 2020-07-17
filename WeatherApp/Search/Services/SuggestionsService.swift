//
//  AutocompleteService.swift
//  WeatherApp
//
//  Created by dludlow7 on 07/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

typealias SuggestionsCompletion = Result<[Suggestion], Error>

class SuggestionsService {

    let suggestionsAPI: SuggestionsAPI

    init(suggestionsAPI: SuggestionsAPI) {
        self.suggestionsAPI = suggestionsAPI
    }

    func getSuggestions(searchString: String, completion: @escaping (SuggestionsCompletion) -> ()) {
        suggestionsAPI.getSuggestionsResponse(for: searchString) { result in
            switch result {
            case .success(let response):
                let suggestions = response.map { suggestionResult -> Suggestion in
                    return Suggestion(displayName: suggestionResult.displayName)
                }
                completion(.success(suggestions))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
