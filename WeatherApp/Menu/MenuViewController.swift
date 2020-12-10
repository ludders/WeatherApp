//
//  MenuViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 07/12/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    let label = UILabel()

    override func viewDidLoad() {
        view.backgroundColor = Theme.Colours.bbcGrey
        label.text = "Menu goes here"
        label.textColor = Theme.Colours.white
        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }
}

extension MenuViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideRightMenuAnimationController()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideRightMenuAnimationController()
    }
}
