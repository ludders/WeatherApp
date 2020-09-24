//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 10/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewTableViewModel {
    var numberOfRows: Int { get }
    var numberOfSections: Int { get }
}

class SearchViewModel {
    private let suggestionsService: SuggestionsService
    private var timer: Timer?

    private(set) var searchModel = Observable<SearchModel?>(nil)
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

extension SearchViewModel: SearchViewTableViewModel {
    public var numberOfRows: Int {
        guard let model = searchModel.value else {
            return 0
        }
        switch model.state {
        case .hasLoaded:
            return model.suggestions.count
        case .isLoading, .hasError(_):
            return 1
        }
    }

    public var numberOfSections: Int {
        return 1
    }

    public func viewModelForCellAt(index: Int, searchText: String) -> SuggestionCellViewModel {
        guard let searchModel = searchModel.value else {
            fatalError("No SearchViewModel exists!")
        }
        var cellViewModel = SuggestionCellViewModel()

        switch searchModel.state {
        case .hasLoaded:
            cellViewModel.text = searchModel.suggestions[index].displayName
        case .hasError(let error):
            switch error {
            case .error(let statusCode):
                if let statusCode = statusCode,
                    statusCode == 404 {
                    cellViewModel.text = NSLocalizedString("No results found for ", comment: "No results found for ") + "\(searchText)"
                }
                else {
                    cellViewModel.text = NSLocalizedString("Error fetching results, please try again", comment: "Error fetching results, please try again")
                }
            }
            cellViewModel.textColor = Theme.Colours.bbcRed
            break
        case .isLoading:
            cellViewModel.text = NSLocalizedString("Loading...", comment: "Loading...")
            cellViewModel.textColor = Theme.Colours.silver
        }
        return cellViewModel
    }
}

struct SuggestionCellViewModel {
    var text: String?
    var textColor: UIColor = Theme.Colours.white
    var backgroundColor: UIColor = Theme.Colours.black
}
