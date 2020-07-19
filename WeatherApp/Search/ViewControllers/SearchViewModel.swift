//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 10/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class SearchViewModel {
    private let suggestionsService: SuggestionsService
    private var timer: Timer?

    private(set) var suggestionsModel = Observable<SuggestionsModel?>(nil)
    public var numberOfSuggestions: Int {
        return suggestionsModel.value?.suggestions.count ?? 0
    }

    init(suggestionsService: SuggestionsService) {
        self.suggestionsService = suggestionsService
    }

    func searchTextDidChange(to text: String) {
        suggestionsModel.value = SuggestionsModel(suggestions: [], state: .isLoading)

        timer?.invalidate()
        if text.count >= 3 {
            timer = Timer(timeInterval: 0.2, repeats: false, block: { _ in
                self.suggestionsService.getSuggestions(searchString: text) { result in
                    switch result {
                    case .success(let suggestions):
                        self.suggestionsModel.value = SuggestionsModel(suggestions: suggestions, state: .hasLoaded)
                    case.failure(let error):
                        self.suggestionsModel.value?.state = .hasError(error)
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
        suggestionsModel.value = SuggestionsModel(suggestions: [], state: .hasLoaded)
    }
}

struct SuggestionsModel {
    var suggestions: [Suggestion]
    var state: SuggestionsState
}

enum SuggestionsState {
    case isLoading, hasLoaded, hasError(Error)
}
