//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 01/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {

    var containerView: UIView!

    override func loadView() {
        containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = UIColor.red
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
