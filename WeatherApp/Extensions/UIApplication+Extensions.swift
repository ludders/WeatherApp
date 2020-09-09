//
//  UIApplication+Extensions.swift
//  WeatherApp
//
//  Created by dludlow7 on 08/09/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var currentWindow: UIWindow? {
        return UIApplication.shared.windows.filter({$0.isKeyWindow}).first
    }
}
