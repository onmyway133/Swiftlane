import XCTest

import pumaTests

var tests = [XCTestCaseEntry]()
tests += pumaTests.allTests()
XCTMain(tests)
