//
//  WorkingDirectory.swift
//  PumaCore
//
//  Created by khoa on 01/12/2019.
//

import Foundation

public class WorkingDirectory: UsesCommandLine {
    public var program: String { "pwd" }
    public var arguments = [String]()
    public weak var workflow: Workflow?

    public init(_ closure: (WorkingDirectory) -> Void = { _ in }) {
        closure(self)
    }

    public func run() throws {
        let process = Process()
        process.launchPath = "/bin/pwd"

        try process.run()
    }
}

extension WorkingDirectory: Task {
    public var name: String { "Working directory" }
}

public extension WorkingDirectory {
    func change(_ workingDirectory: String) {
        workflow?.workingDirectory = workingDirectory
    }
}
