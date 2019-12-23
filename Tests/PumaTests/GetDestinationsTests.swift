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

    func testRegexVersion() throws {
        let string = "iPad Air (11.0.1) [7A5EAD29-D870-49FB-9A9B-C81079620AC9] (Simulator)"
        let matches = try string.matches(pattern: #"\((\d+\.)?(\d+\.)?(\*|\d+)\)"#)
        XCTAssertEqual(matches.first, "(11.0.1)")
    }

    func testParse() throws {
        let string = "iPad Air (11.0.1) [7A5EAD29-D870-49FB-9A9B-C81079620AC9] (Simulator)"
        let getDestinations = GetDestinations()
        let destination = getDestinations.parse(string)!

        XCTAssertEqual(
            destination.kind,
            Destination.Kind.withoutId(
                name: "iPad Air",
                platform: "iOS Simulator",
                os: "11.0.1"
            )
        )
    }
}
