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
        let string = "iPad Air (11.0.1) [7A5EAD29-D870-49FB-9A9B-C81079620AC9] (Simulator)"
        let matches = try string.matches(pattern: #"\[.+\]"#)
        XCTAssertEqual(matches.first, "[7A5EAD29-D870-49FB-9A9B-C81079620AC9]")
    }
}
