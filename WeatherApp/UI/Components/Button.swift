//
//  Button.swift
//  WeatherApp
//
//  Created by dludlow7 on 09/09/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton {

    typealias ButtonClosure = () -> ()

    private var _touchUpInside: ButtonClosure?
    private var _touchUpOutside: ButtonClosure?

    public func onTouchUpInside(_ closure: @escaping ButtonClosure) {
        _touchUpInside = closure
        self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }

    @objc
    private func touchUpInside() {
        _touchUpInside?()
    }
}
