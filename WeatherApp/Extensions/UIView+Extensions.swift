//
//  UIView+Extensions.swift
//  WeatherApp
//
//  Created by dludlow7 on 19/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

extension UIView {

    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }

    func displayLoadingView() {
        let loadingView = RGBLoadingView()
        guard let window = UIApplication.shared.currentWindow else { return }
        window.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(window)
        }
        loadingView.startAnimation()
    }

    func hideLoadingView() {
        guard let window = UIApplication.shared.currentWindow else { return }
        window.subviews.filter { $0.isKind(of: RGBLoadingView.self) }
            .forEach { $0.fadeOutAndRemoveFromSuperview() }
    }

    func fadeOutAndRemoveFromSuperview() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
