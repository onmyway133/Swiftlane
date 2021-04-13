//
//  Wait.swift
//  PumaCore
//
//  Created by khoa on 01/01/2020.
//

import Foundation

public class Wait {
    public var name: String = "Wait"
    public var isEnabled = true

    private let seconds: TimeInterval

    public init(seconds: TimeInterval = 0) {
        self.seconds = seconds
    }
}

// MARK: - Task

extension Wait: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            completion(.success(()))
        })

        RunLoop.current.run(until: Date(timeIntervalSinceNow: seconds))
    }
}
