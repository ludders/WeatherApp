//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by dludlow7 on 01/12/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {

    func testAttributedStringWithAttachments() {

        let images = [UIImage(systemName: "play")!, UIImage(systemName: "pause")!, UIImage(systemName: "stop")!]
        let imageAttachments = images.map { return NSTextAttachment(image: $0) }
        let imageStrings = imageAttachments.map { return NSAttributedString(attachment: $0) }

        let expectedString = NSMutableAttributedString()
        expectedString.append(NSAttributedString(string: "This "))
        expectedString.append(imageStrings[0])
        expectedString.append(NSAttributedString(string: " is "))
        expectedString.append(imageStrings[1])
        expectedString.append(NSAttributedString(string: " a "))
        expectedString.append(imageStrings[2])
        expectedString.append(NSAttributedString(string: " test"))

        let actualString = "This | is | a | test".attributedString(with: imageAttachments, replacing: "|")

        XCTAssertEqual(actualString, expectedString)
    }

    func testAttributedStringWithAttachmentsAtFirstAndLastCharacter() {

        let images = [UIImage(systemName: "play")!, UIImage(systemName: "pause")!, UIImage(systemName: "stop")!]
        let imageAttachments = images.map { return NSTextAttachment(image: $0) }
        let imageStrings = imageAttachments.map { return NSAttributedString(attachment: $0) }

        let expectedString = NSMutableAttributedString()
        expectedString.append(imageStrings[0])
        expectedString.append(NSAttributedString(string: "This "))
        expectedString.append(imageStrings[1])
        expectedString.append(NSAttributedString(string: " is a test"))
        expectedString.append(imageStrings[2])

        let actualString = "|This | is a test|".attributedString(with: imageAttachments, replacing: "|")

        XCTAssertEqual(actualString, expectedString)
    }
}
