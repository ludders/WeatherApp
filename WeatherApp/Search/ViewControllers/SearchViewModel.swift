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

    private(set) var suggestionsModel = Observable<[Suggestion]?>(nil)
    public var numberOfSuggestions: Int {
        return suggestionsModel.value?.count ?? 0
    }

    init(suggestionsService: SuggestionsService) {
        self.suggestionsService = suggestionsService
    }

    func searchTextDidChange(to text: String) {
        timer?.invalidate()

        if text.count >= 3 {
            timer = Timer(timeInterval: 0.2, repeats: false, block: { _ in
                self.suggestionsService.getSuggestions(searchString: text) { result in
                    switch result {
                    case .success(let suggestions):
                        self.suggestionsModel.value = suggestions
                    case.failure(let error):
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
        suggestionsModel.value = []
    }
}
