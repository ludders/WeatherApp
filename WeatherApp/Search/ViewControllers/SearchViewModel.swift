//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 10/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate {
    
}

class SearchViewModel {
    private let suggestionsService: SuggestionsService
    private var timer: Timer?

    private(set) var searchModel = Observable<SearchModel?>(nil)
    public var numberOfSuggestions: Int {
        return searchModel.value?.suggestions.count ?? 0
    }
    private(set) var selectedLocation: Location? = nil

    init(suggestionsService: SuggestionsService) {
        self.suggestionsService = suggestionsService
    }

    func searchTextDidChange(to text: String) {
        searchModel.value = SearchModel(suggestions: [], state: .isLoading)

        timer?.invalidate()
        if text.count >= 3 {
            timer = Timer(timeInterval: 0.2, repeats: false, block: { _ in
                self.suggestionsService.getSuggestions(searchString: text) { result in
                    switch result {
                    case .success(let suggestions):
                        self.searchModel.value = SearchModel(suggestions: suggestions, state: .hasLoaded)
                    case.failure(let error):
                        self.searchModel.value?.state = .hasError(error)
                        break
                    }
                }
            })
            RunLoop.current.add(timer!, forMode: .default)
        } else {
            clearSuggestions()
        }
    }

    func clearSuggestions() {
        searchModel.value = SearchModel(suggestions: [], state: .hasLoaded)
    }

    func handleSelection(at index: Int) {
        guard let selectedSuggestion = searchModel.value?.suggestions[index] else { return }
        selectedLocation = Location(name: selectedSuggestion.shortName,
                                coordinates: selectedSuggestion.coordinates)
    }
}
