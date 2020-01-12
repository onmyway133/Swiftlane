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

    private var seconds: TimeInterval = 0

    public init(_ closure: (Wait) -> Void = { _ in }) {
        closure(self)
    }
}

extension Wait: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            completion(.success(()))
        })

        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: seconds))
    }
}

public extension Wait {
    func wait(for seconds: TimeInterval) {
        self.seconds = seconds
    }
}
