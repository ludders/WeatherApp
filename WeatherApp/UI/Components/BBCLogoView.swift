//
//  BBCLogoView.swift
//  WeatherApp
//
//  Created by dludlow7 on 24/04/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

final class BBCLogoView: UIView {

    //TODO: Animate this as per original 90s BBC intro animation

    private var letterBoxesLayer: CAShapeLayer!
    private var lettersLayer: CAShapeLayer!
    private var blueBarlayer: CAShapeLayer!
    private var redBarLayer: CAShapeLayer!
    private var greenBarLayer: CAShapeLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 278.58, height: 85.31)
    }

    private func addSubLayers() {
        //Letter Boxes
        letterBoxesLayer = CAShapeLayer()
        letterBoxesLayer.fillColor = Theme.Colours.bbcGrey.cgColor
        letterBoxesLayer.path = letter_boxes_path
        layer.addSublayer(letterBoxesLayer)

        //Letters
        lettersLayer = CAShapeLayer()
        lettersLayer.fillColor = Theme.Colours.white.cgColor
        lettersLayer.path = letters_path
        layer.addSublayer(lettersLayer)

        //Blue Bar
        blueBarlayer = CAShapeLayer()
        blueBarlayer.fillColor = Theme.Colours.bbcBlue.cgColor
        blueBarlayer.path = blue_bar_path
        layer.addSublayer(blueBarlayer)

        //Red Bar
        redBarLayer = CAShapeLayer()
        redBarLayer.fillColor = Theme.Colours.bbcRed.cgColor
        redBarLayer.path = red_bar_path
        layer.addSublayer(redBarLayer)

        //Green Bar
        greenBarLayer = CAShapeLayer()
        greenBarLayer.fillColor = Theme.Colours.bbcGreen.cgColor
        greenBarLayer.path = green_bar_path
        layer.addSublayer(greenBarLayer)
    }

    private var b1_box_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 26.13, y: 0.25))
        path.addLine(to: CGPoint(x: 5.24, y: 68.59))
        path.addLine(to: CGPoint(x: 75.57, y: 68.59))
        path.addLine(to: CGPoint(x: 96.47, y: 0.25))
        path.addLine(to: CGPoint(x: 26.13, y: 0.25))
        return path
    }

    private var b2_box_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 117.41, y: 0.25))
        path.addLine(to: CGPoint(x: 96.52, y: 68.59))
        path.addLine(to: CGPoint(x: 166.85, y: 68.59))
        path.addLine(to: CGPoint(x: 187.75, y: 0.25))
        path.addLine(to: CGPoint(x: 117.41, y: 0.25))
        return path
    }

    private var c_box_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 208.25, y: 0.25))
        path.addLine(to: CGPoint(x: 187.36, y: 68.59))
        path.addLine(to: CGPoint(x: 257.69, y: 68.59))
        path.addLine(to: CGPoint(x: 278.58, y: 0.25))
        path.addLine(to: CGPoint(x: 208.25, y: 0.25))
        return path
    }

    private var b1_letter_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 63.41, y: 33.43))
        path.addCurve(to: CGPoint(x: 72.81, y: 26.35), control1: CGPoint(x: 65.88, y: 33.43), control2: CGPoint(x: 71.11, y: 31.91))
        path.addCurve(to: CGPoint(x: 63.17, y: 14.19), control1: CGPoint(x: 74.51, y: 20.8), control2: CGPoint(x: 72.1, y: 14.19))
        path.addLine(to: CGPoint(x: 38.92, y: 14.19))
        path.addLine(to: CGPoint(x: 26.54, y: 54.66))
        path.addLine(to: CGPoint(x: 51.27, y: 54.66))
        path.addCurve(to: CGPoint(x: 69.03, y: 44.96), control1: CGPoint(x: 58.91, y: 54.66), control2: CGPoint(x: 66.89, y: 51.96))
        path.addCurve(to: CGPoint(x: 63.41, y: 33.43), control1: CGPoint(x: 71.95, y: 35.42), control2: CGPoint(x: 63.41, y: 33.43))
        path.closeSubpath()
        path.move(to: CGPoint(x: 50.02, y: 23.39))
        path.addLine(to: CGPoint(x: 57.25, y: 23.39))
        path.addCurve(to: CGPoint(x: 55.18, y: 30.17), control1: CGPoint(x: 61.55, y: 23.39), control2: CGPoint(x: 60.19, y: 30.17))
        path.addLine(to: CGPoint(x: 47.95, y: 30.17))
        path.addLine(to: CGPoint(x: 50.02, y: 23.39))
        path.closeSubpath()
        path.move(to: CGPoint(x: 51.18, y: 44.96))
        path.addLine(to: CGPoint(x: 43.42, y: 44.96))
        path.addLine(to: CGPoint(x: 45.88, y: 36.93))
        path.addLine(to: CGPoint(x: 52.58, y: 36.93))
        path.addCurve(to: CGPoint(x: 51.18, y: 44.96), control1: CGPoint(x: 57.67, y: 36.93), control2: CGPoint(x: 56.67, y: 44.96))
        path.closeSubpath()
        return path
    }

    private var b2_letter_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 154.65, y: 33.43))
        path.addCurve(to: CGPoint(x: 164.05, y: 26.35), control1: CGPoint(x: 157.11, y: 33.43), control2: CGPoint(x: 162.35, y: 31.91))
        path.addCurve(to: CGPoint(x: 154.41, y: 14.19), control1: CGPoint(x: 165.74, y: 20.8), control2: CGPoint(x: 163.33, y: 14.19))
        path.addLine(to: CGPoint(x: 130.15, y: 14.19))
        path.addLine(to: CGPoint(x: 117.78, y: 54.66))
        path.addLine(to: CGPoint(x: 142.51, y: 54.66))
        path.addCurve(to: CGPoint(x: 160.27, y: 44.96), control1: CGPoint(x: 150.14, y: 54.66), control2: CGPoint(x: 158.13, y: 51.96))
        path.addCurve(to: CGPoint(x: 154.65, y: 33.43), control1: CGPoint(x: 163.18, y: 35.42), control2: CGPoint(x: 154.65, y: 33.43))
        path.closeSubpath()
        path.move(to: CGPoint(x: 141.25, y: 23.39))
        path.addLine(to: CGPoint(x: 148.49, y: 23.39))
        path.addCurve(to: CGPoint(x: 146.42, y: 30.17), control1: CGPoint(x: 152.78, y: 23.39), control2: CGPoint(x: 151.43, y: 30.17))
        path.addLine(to: CGPoint(x: 139.18, y: 30.17))
        path.addLine(to: CGPoint(x: 141.25, y: 23.39))
        path.closeSubpath()
        path.move(to: CGPoint(x: 142.41, y: 44.96))
        path.addLine(to: CGPoint(x: 134.66, y: 44.96))
        path.addLine(to: CGPoint(x: 137.11, y: 36.93))
        path.addLine(to: CGPoint(x: 143.81, y: 36.93))
        path.addCurve(to: CGPoint(x: 142.41, y: 44.96), control1: CGPoint(x: 148.9, y: 36.93), control2: CGPoint(x: 147.9, y: 44.96))
        path.closeSubpath()
        return path
    }

    private var c_letter_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 239.18, y: 38.05))
        path.addLine(to: CGPoint(x: 253.06, y: 38.05))
        path.addCurve(to: CGPoint(x: 229.63, y: 56.71), control1: CGPoint(x: 249.69, y: 49.05), control2: CGPoint(x: 243.31, y: 56.71))
        path.addCurve(to: CGPoint(x: 213.93, y: 33.77), control1: CGPoint(x: 214.26, y: 56.71), control2: CGPoint(x: 210.76, y: 44.15))
        path.addCurve(to: CGPoint(x: 239.07, y: 12.75), control1: CGPoint(x: 216.3, y: 26.04), control2: CGPoint(x: 223.33, y: 12.75))
        path.addCurve(to: CGPoint(x: 255.12, y: 30.73), control1: CGPoint(x: 256.19, y: 12.75), control2: CGPoint(x: 256.52, y: 26.17))
        path.addLine(to: CGPoint(x: 240.97, y: 30.73))
        path.addCurve(to: CGPoint(x: 237.65, y: 23.66), control1: CGPoint(x: 242.35, y: 27.76), control2: CGPoint(x: 241.15, y: 23.66))
        path.addCurve(to: CGPoint(x: 228.25, y: 34.73), control1: CGPoint(x: 234.15, y: 23.66), control2: CGPoint(x: 230.38, y: 27.76))
        path.addCurve(to: CGPoint(x: 231.43, y: 45.74), control1: CGPoint(x: 226.12, y: 41.71), control2: CGPoint(x: 227.59, y: 45.74))
        path.addCurve(to: CGPoint(x: 239.18, y: 38.05), control1: CGPoint(x: 235.26, y: 45.74), control2: CGPoint(x: 238.5, y: 40.27))
        path.closeSubpath()
        return path
    }

    private var blue_bar_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 2.19, y: 78.56))
        path.addLine(to: CGPoint(x: 0.13, y: 85.31))
        path.addLine(to: CGPoint(x: 70.46, y: 85.31))
        path.addLine(to: CGPoint(x: 72.53, y: 78.56))
        path.addLine(to: CGPoint(x: 2.19, y: 78.56))
        return path
    }

    private var red_bar_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 93.47, y: 78.56))
        path.addLine(to: CGPoint(x: 91.41, y: 85.31))
        path.addLine(to: CGPoint(x: 161.74, y: 85.31))
        path.addLine(to: CGPoint(x: 163.81, y: 78.56))
        path.addLine(to: CGPoint(x: 93.47, y: 78.56))
        return path
    }

    private var green_bar_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 184.31, y: 78.56))
        path.addLine(to: CGPoint(x: 182.24, y: 85.31))
        path.addLine(to: CGPoint(x: 252.58, y: 85.31))
        path.addLine(to: CGPoint(x: 254.64, y: 78.56))
        path.addLine(to: CGPoint(x: 184.31, y: 78.56))
        return path
    }

    private var letter_boxes_path: CGPath {
        let path = CGMutablePath()
        path.addPath(b1_box_path)
        path.addPath(b2_box_path)
        path.addPath(c_box_path)
        return path
    }

    private var letters_path: CGPath {
        let path = CGMutablePath()
        path.addPath(b1_letter_path)
        path.addPath(b2_letter_path)
        path.addPath(c_letter_path)
        return path
    }
}
