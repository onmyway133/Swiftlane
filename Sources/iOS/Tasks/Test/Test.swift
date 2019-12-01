//
//  Test.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import PumaCore

public class Test: UsesXcodeBuild {
    public var arguments = [String]()

    public init(_ closure: (Test) -> Void = { _ in }) {
        closure(self)
    }
}

extension Test: Task {
    public var name: String { "Test" }

    public func run() throws {
        arguments.append("test")
        try (self as UsesCommandLine).run()
    }
}

public extension Test {
    func destination(_ destination: Destination) {
        arguments.append("-destination \(destination.toString())")
    }

    func testsWithoutBuilding(enabled: Bool) {
        if enabled {
            arguments.append("test-without-building")
        } else {
            arguments.remove("test-without-building")
        }
    }
}
