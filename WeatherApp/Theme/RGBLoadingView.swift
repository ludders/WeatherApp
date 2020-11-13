//
//  RGBLoadingView.swift
//  WeatherApp
//
//  Created by dludlow7 on 29/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

final class RGBLoadingView: UIView {
    private var spinner = RGBSpinnerView()

    init() {
        super.init(frame: .zero)
        backgroundColor = Theme.Colours.black
        alpha = 0.8
        addSubview(spinner)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        spinner.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }

    func startAnimation() {
        spinner.startAnimation()
    }

    func stopAnimation() {
        spinner.stopAnimation()
    }
}

final class RGBSpinnerView: UIView {

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
        return CGSize(width: 254.64, height: 6.75)
//        return CGSize(width: 37.724444444444, height: 1) minimum equivalent size?
    }

    private func addSubLayers() {
        blueBarlayer = CAShapeLayer()
        blueBarlayer.fillColor = Theme.Colours.bbcBlue.cgColor
        blueBarlayer.path = blue_bar_path
        layer.addSublayer(blueBarlayer)

        redBarLayer = CAShapeLayer()
        redBarLayer.fillColor = Theme.Colours.bbcRed.cgColor
        redBarLayer.path = red_bar_path
        layer.addSublayer(redBarLayer)

        greenBarLayer = CAShapeLayer()
        greenBarLayer.fillColor = Theme.Colours.bbcGreen.cgColor

        greenBarLayer.path = green_bar_path
        layer.addSublayer(greenBarLayer)
    }

    private var blue_bar_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 2.19, y: 0))
        path.addLine(to: CGPoint(x: 0.13, y: 6.75))
        path.addLine(to: CGPoint(x: 70.46, y: 6.75))
        path.addLine(to: CGPoint(x: 72.53, y: 0))
        path.addLine(to: CGPoint(x: 2.19, y: 0))
        return path
    }

    private var red_bar_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 93.47, y: 0))
        path.addLine(to: CGPoint(x: 91.41, y: 6.75))
        path.addLine(to: CGPoint(x: 161.74, y: 6.75))
        path.addLine(to: CGPoint(x: 163.81, y: 0))
        path.addLine(to: CGPoint(x: 93.47, y: 0))
        return path
    }

    private var green_bar_path: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 184.31, y: 0))
        path.addLine(to: CGPoint(x: 182.24, y: 6.75))
        path.addLine(to: CGPoint(x: 252.58, y: 6.75))
        path.addLine(to: CGPoint(x: 254.64, y: 0))
        path.addLine(to: CGPoint(x: 184.31, y: 0))
        return path
    }

    public func startAnimation() {

        let blueAnimation = createFadeInOutAnimation(timeOffset: 0)
        let redAnimation = createFadeInOutAnimation(timeOffset: 0.1)
        let greenAnimation = createFadeInOutAnimation(timeOffset: 0.2)

        blueBarlayer.add(blueAnimation, forKey: "opacity")
        redBarLayer.add(redAnimation, forKey: "opacity")
        greenBarLayer.add(greenAnimation, forKey: "opacity")
    }

    public func stopAnimation() {
        blueBarlayer.removeAllAnimations()
        redBarLayer.removeAllAnimations()
        greenBarLayer.removeAllAnimations()
    }

    private func createFadeInOutAnimation(timeOffset: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.2
        animation.toValue = 1
        animation.duration = 0.5
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.repeatDuration = .infinity
        animation.timeOffset = timeOffset
        return animation
    }
}

