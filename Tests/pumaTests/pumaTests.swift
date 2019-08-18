import XCTest
@testable import Puma

final class PumaTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(puma().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
