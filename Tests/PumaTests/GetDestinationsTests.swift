//
//  GetDestinationsTests.swift
//  Puma
//
//  Created by khoa on 27/12/2019.
//


import XCTest
@testable import Puma
@testable import PumaiOS
@testable import PumaCore

final class GetDestinationsTests: XCTestCase {
    func testRegex() throws {
        let string = "com.apple.CoreSimulator.SimRuntime.iOS-13-2"
        let matches = try string.matches(pattern: #"(-\d+)+"#)
        XCTAssertEqual(matches.first, "-13-2")
    }
}
