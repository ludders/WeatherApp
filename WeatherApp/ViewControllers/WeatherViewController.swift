//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 23/05/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {

    var weatherView: WeatherView!
    var colour: UIColor

    init(colour: UIColor) {
        self.colour = colour
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        weatherView = WeatherView()
        weatherView.backgroundColor = colour
        view = weatherView
    }

    override func viewDidLoad() {
        print("it loaded!")
        weatherView.setupView()
    }
}
