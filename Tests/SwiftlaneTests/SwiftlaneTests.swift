import XCTest
@testable import Swiftlane

final class SwiftlaneTests: XCTestCase {
    func testArgs() {
        var args = Args()
        args["-key1"] = "value1"
        args["-key2"] = "=value2"
        args[multiple: "-key3"] = "value3"
        args[multiple: "-key4"] = "=value4"
        args.flag("build")

        XCTAssertEqual(
            args.toString(),
            "build -key1 value1 -key2=value2 -key3 value3 -key4=value4"
        )
    }

    func testBuild() async throws {
        let build = Build()
        build.project("MyApp")
        build.scheme("Staging")
        build.configuration(.release)
    }
}
