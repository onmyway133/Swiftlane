//
//  Concurrent.swift
//  Puma
//
//  Created by khoa on 12/12/2019.
//

import Foundation

/// Run tasks concurrently
public class Concurrent: Task {
    public let name: String = "Concurrent"
    public var isEnabled = true
    public let tasks: [Task]

    private let serialQueue = DispatchQueue(label: "InternalSerialQueue")

    public init(tasks: [Task]) {
        self.tasks = tasks
    }

    public init(@TaskBuilder builder: () -> [Task]) {
        self.tasks = builder()
    }

    public init(@TaskBuilder builder: () -> Task) {
        self.tasks = [builder()]
    }

    public func run(workflow: Workflow, completion: @escaping (Result<(), Error>) -> Void) {
        var runTaskCount = 0
        let taskCount = tasks.count

        tasks.forEach { task in
            Deps.console.newLine()
            Deps.console.title("🚀 \(task.name)")
            task.run(workflow: workflow, completion: { _ in
                self.serialQueue.async {
                    runTaskCount += 1
                    if runTaskCount == taskCount {
                        completion(.success(()))
                    }
                }
            })
        }
    }
}
