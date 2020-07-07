//
//  API.swift
//  WeatherApp
//
//  Created by dludlow7 on 18/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

protocol API {
    var scheme: String { get }
    var domainName: String { get }
    var path: String { get }

    func getURLComponents() -> URLComponents
}
