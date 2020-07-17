//
//  WindIconView.swift
//  WeatherApp
//
//  Created by dludlow7 on 17/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

final class WindIconView: UIView {

    public var degrees: Int = 0 {
        didSet {
            rotateIcon(by: degrees)
        }
    }
    private var iconCircleView = WindIconCircleView()
    private var iconArrowView = WindIconArrowView()
    private var iconView = UIView()
    public var label = UILabel()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("No storyboards!")
    }

    fileprivate func setupView() {
        iconView.backgroundColor = Theme.Colours.transparent
        addSubview(iconView)

        iconCircleView.backgroundColor = Theme.Colours.transparent
        iconView.addSubview(iconCircleView)

        iconArrowView.backgroundColor = Theme.Colours.transparent
        iconView.addSubview(iconArrowView)

        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = Theme.Fonts.BBC.largeTitle50
        label.textAlignment = .center
        label.numberOfLines = 0
        addSubview(label)

        setupConstraints()
    }

    fileprivate func setupConstraints() {
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)

        iconView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconCircleView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(0.5)
        }
        iconArrowView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().dividedBy(2)
            make.centerX.equalTo(iconCircleView)
            make.top.equalToSuperview()
            make.width.equalTo(iconCircleView).multipliedBy(0.9)
        }
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(iconCircleView)
            make.height.width.equalTo(iconCircleView).multipliedBy(0.8)
        }
    }

    fileprivate func rotateIcon(by degrees: Int) {
        DispatchQueue.main.async {
            self.iconView.transform = CGAffineTransform(rotationAngle: CGFloat(integerLiteral: degrees) * (CGFloat.pi / 180))
        }
    }
}

fileprivate class WindIconCircleView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2),
                                radius: frame.width / 2,
                                startAngle: 0,
                                endAngle: CGFloat.pi * 2,
                                clockwise: true)
        tintColor.setFill()
        path.fill()
    }
}

fileprivate class WindIconArrowView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let h = frame.height
        let w = frame.width
        path.move(to: CGPoint(x: 0.2 * w, y: h))
        path.addLine(to: CGPoint(x: 0.2 * w, y: 0.33 * h))
        path.addLine(to: CGPoint(x: 0, y: 0.33 * h))
        path.addLine(to: CGPoint(x: 0.5 * w, y: 0))
        path.addLine(to: CGPoint(x: w, y: 0.33 * h))
        path.addLine(to: CGPoint(x: 0.8 * w, y: 0.33 * h))
        path.addLine(to: CGPoint(x: 0.8 * w, y: h))
        path.addLine(to: CGPoint(x: 0.2 * w, y: h))
        tintColor.setFill()
        path.fill()
    }
}
