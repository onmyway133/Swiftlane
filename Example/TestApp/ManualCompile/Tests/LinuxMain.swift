import XCTest

import ManualCompileTests

var tests = [XCTestCaseEntry]()
tests += ManualCompileTests.allTests()
XCTMain(tests)
