import XCTest
@testable import Puma

final class PumaTests: XCTestCase {
    func testParse() {
        let string = "iPad Air (11.0.1) [7A5EAD29-D870-49FB-9A9B-C81079620AC9] (Simulator)"
        let getDestinations = GetDestinations()
        let destination = getDestinations.getAvailableDestinations().first!

        XCTAssert(destination.name, "iPad Air")
        XCTAssert(destination.os, "11.0.1")
        XCTAssert(destination.platform, "iOS Simulator")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
