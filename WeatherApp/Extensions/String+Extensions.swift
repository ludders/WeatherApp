//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by dludlow7 on 28/11/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

extension String {

    var asDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        return formatter.date(from: self)
    }

    func attributedString(with attachments: [NSTextAttachment], replacing token: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString()

        let subStrings = self.components(separatedBy: token)

        for (subString, attachment) in zip(subStrings, attachments) {
            mutableString.append(NSAttributedString(string: String(subString)))
            mutableString.append(NSAttributedString(attachment: attachment))
        }

        if subStrings.count > attachments.count {
            mutableString.append(NSAttributedString(string: String(subStrings.last!)))
        }

        return mutableString
    }
}
