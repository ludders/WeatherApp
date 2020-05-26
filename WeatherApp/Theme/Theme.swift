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
        public static var transparent: UIColor {
            return UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        }
        public static var black: UIColor {
            return UIColor(hex: "#000000")
        }
    }

    public struct Fonts {
        public struct BBC {
            private static var boldItalic = "HelveticaNeue-BoldItalic"
            private static var italic = "HelveticaNeue-Italic"
            private static var regular = "HelveticaNeue"
            public static var largeTitle: UIFont {
                let size = CGFloat(50)
                return UIFont(name: boldItalic, size: size) ?? UIFont.systemFont(ofSize: size)
            }
            public static var largeSubTitle: UIFont {
                let size = CGFloat(34)
                return UIFont(name: italic, size: size) ?? UIFont.systemFont(ofSize: size)
            }
            public static var body: UIFont {
                let size = CGFloat(17)
                return UIFont(name: regular, size: size) ?? UIFont.systemFont(ofSize: size)
            }
            public static var callout: UIFont {
                let size = CGFloat(16)
                return UIFont(name: boldItalic, size: size) ?? UIFont.systemFont(ofSize: size)
            }
            public static var subhead: UIFont {
                let size = CGFloat(15)
                return UIFont(name: regular, size: size) ?? UIFont.systemFont(ofSize: size)
            }
            public static var footnote: UIFont {
                let size = CGFloat(13)
                return UIFont(name: regular, size: size) ?? UIFont.systemFont(ofSize: size)
            }
            public static var caption1: UIFont {
                let size = CGFloat(12)
                return UIFont(name: regular, size: size) ?? UIFont.systemFont(ofSize: size)
            }
            public static var caption2: UIFont {
                let size = CGFloat(11)
                return UIFont(name: regular, size: size) ?? UIFont.systemFont(ofSize: size)
            }
        }
    }
}


//Large (Default)
//Style           Weight      Size (Points)    Leading (Points)
//Large Title     Regular     34    41
//Title 1         Regular     28    34
//Title 2         Regular     22    28
//Title 3         Regular     20    25
//Headline        Semi-Bold   17    22
//Body            Regular     17    22
//Callout         Regular     16    21
//Subhead         Regular     15    20
//Footnote        Regular     13    18
//Caption 1       Regular     12    16
//Caption 2       Regular     11    13
