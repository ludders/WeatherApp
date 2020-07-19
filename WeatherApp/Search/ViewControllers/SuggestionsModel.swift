//
//  SuggestionsModel.swift
//  WeatherApp
//
//  Created by dludlow7 on 19/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

struct SearchModel {
    var suggestions: [Suggestion]
    var state: SuggestionsState
}

enum SuggestionsState {
    case isLoading, hasLoaded, hasError(Error)
}
