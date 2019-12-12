//
//  TestAppUITests.swift
//  TestAppUITests
//
//  Created by khoa on 09/12/2019.
//  Copyright © 2019 PumaSwift. All rights reserved.
//

import XCTest

class TestAppUITests: XCTestCase {
    func testFirstScreen() {
        let app = XCUIApplication()
        app.launch()

        takeScreenshot(name: "01 MainScreen")
    }

    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attach = XCTAttachment(screenshot: screenshot)
        add(attach)
    }
}
