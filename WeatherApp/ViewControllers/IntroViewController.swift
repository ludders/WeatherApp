//
//  IntroViewController.swift
//  WeatherApp
//
//  Created by dludlow7 on 24/04/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import UIKit

protocol IntroViewControllerDelegate: AnyObject {
    func animationDidFInish()
}

class IntroViewController: UIViewController {

    var containerView: UIView!
    var logoView: BBCLogoView!
    var weatherLabel: UILabel!
    weak var delegate: IntroViewControllerDelegate?

    override func loadView() {
        containerView = UIView(frame: UIScreen.main.bounds)
        view = containerView
    }

    override func viewDidLoad() {
        containerView.backgroundColor = UIColor.black
        logoView = BBCLogoView(frame: CGRect.zero)
        containerView.addSubview(logoView)

        logoView.translatesAutoresizingMaskIntoConstraints = false
        let logoConstraints: [NSLayoutConstraint] = [
            logoView.widthAnchor.constraint(equalToConstant: logoView.intrinsicContentSize.width),
            logoView.heightAnchor.constraint(equalToConstant: logoView.intrinsicContentSize.height),
            logoView.centerXAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerYAnchor)
        ]
        NSLayoutConstraint.activate(logoConstraints)

        weatherLabel = UILabel(frame: CGRect.zero)
        weatherLabel.text = "WEATHER"
        weatherLabel.font = Theme.Fonts.bbcFont
        weatherLabel.textColor = Theme.Colours.primaryWhite
        weatherLabel.textAlignment = .center

        containerView.addSubview(weatherLabel)

        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        let weatherConstraints: [NSLayoutConstraint] = [
            weatherLabel.heightAnchor.constraint(equalToConstant: 40),
            weatherLabel.widthAnchor.constraint(equalToConstant: logoView.intrinsicContentSize.width),
            weatherLabel.centerXAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(weatherConstraints)

        super.viewDidLoad()

        for familyName in UIFont.familyNames {
            print(UIFont.fontNames(forFamilyName: familyName))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0.0
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.duration = 2.0
        logoView.layer.add(fadeInAnimation, forKey: "opacity")
        fadeInAnimation.delegate = self
        weatherLabel.layer.add(fadeInAnimation, forKey: "opacity")
    }
}

extension IntroViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        delegate?.animationDidFInish()
    }
}
