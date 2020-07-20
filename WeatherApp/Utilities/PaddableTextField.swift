//
//  UITextField+Extensions.swift
//  WeatherApp
//
//  Created by dludlow7 on 20/07/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class PaddableTextField: UITextField {

    public var overlayViewsEdgeInsets: UIEdgeInsets = .zero

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewFrame = self.leftView!.frame
        return CGRect(x: 0 + overlayViewsEdgeInsets.left, y: overlayViewsEdgeInsets.top, width: leftViewFrame.width, height: leftViewFrame.height)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightViewFrame = self.rightView!.frame
        return CGRect(x: self.frame.width - rightViewFrame.width - overlayViewsEdgeInsets.right, y: overlayViewsEdgeInsets.top, width: rightViewFrame.width, height: rightViewFrame.height)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: overlayViewsEdgeInsets))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.inset(by: overlayViewsEdgeInsets))
    }
}
