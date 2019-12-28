//
//  SummarizerTests.swift
//  Puma
//
//  Created by khoa on 27/12/2019.
//

import Foundation
import XCTest
@testable import Puma
@testable import PumaiOS
@testable import PumaCore

private class MockTask: Task {
    var name = "Mock task"
    var isEnabled: Bool = true
    func run(workflow: Workflow, completion: @escaping TaskCompletion) {}
}

final class SummarizerTests: XCTestCase {
    func testAccumulate() throws {
        let task = Sequence {
            Concurrent {
                MockTask()
                MockTask()
                MockTask()
            }

            Sequence {
                Concurrent {
                    MockTask()
                    MockTask()
                }

                Sequence {
                    MockTask()
                }
            }
        }

        let summarizer = Summarizer()
        summarizer.update(tasks: [task])
        XCTAssertEqual(summarizer.records.count, 6)
    }
}
