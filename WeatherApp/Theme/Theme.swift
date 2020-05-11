//
//  Theme.swift
//  WeatherApp
//
//  Created by dludlow7 on 24/04/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

public struct Theme {

    public struct Colours {
        public static var primaryGrey: UIColor {
            return UIColor(hex: "#333E48")
        }
        public static var primaryWhite: UIColor {
            return UIColor(hex: "#FFFFFF")
        }
        public static var primaryRed: UIColor {
            return UIColor(hex: "#E2231A")
        }
        public static var primaryGreen: UIColor {
            return UIColor(hex: "#00AF41")
        }
        public static var primaryBlue: UIColor {
            return UIColor(hex: "#0082CA")
        }
    }

    public struct Fonts {
        public static var bbcFont: UIFont {
            return UIFont(name: "HelveticaNeue-BoldItalic", size: 30.0) ?? UIFont.systemFont(ofSize: 30.0)
        }
    }
}
