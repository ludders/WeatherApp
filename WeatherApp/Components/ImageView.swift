//
//  ImageView.swift
//  WeatherApp
//
//  Created by dludlow7 on 11/09/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class ImageView: UIImageView {
    typealias TapGestureAction = () -> ()
    private var tapGestureAction: TapGestureAction?
    private var tapGestureRecognizer: UITapGestureRecognizer?

    func addTapGestureRecognizer(_ tapGestureAction: @escaping TapGestureAction) {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(_tapGestureAction))
        self.addGestureRecognizer(tapGestureRecognizer!)
    }

    @objc
    private func _tapGestureAction() {
        tapGestureAction?()
    }
}
