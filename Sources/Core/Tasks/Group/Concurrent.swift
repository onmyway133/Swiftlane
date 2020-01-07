//
//  Concurrent.swift
//  Puma
//
//  Created by khoa on 12/12/2019.
//

import Foundation

/// Run tasks concurrently
public class Concurrent: Task {
    public var name: String = "Concurrent"
    public var isEnabled = true
    public let tasks: [Task]

    private let runQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
    private let checkQueue = DispatchQueue(label: "SerialQueue")

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
        let semaphore = DispatchSemaphore(value: 0)

        tasks.forEach { task in
            workflow.logger.newLine()
            workflow.logger.task(task.name)

            workflow.summarizer.track(task: task, startAt: Deps.date())
            self.runQueue.async {
                task.run(workflow: workflow, completion: { result in
                    self.checkQueue.async {
                        switch result {
                        case .success:
                            workflow.summarizer.track(task: task, finishAt: Deps.date())
                        case .failure(let error):
                            workflow.summarizer.track(task: task, error: error)
                        }

                        runTaskCount += 1
                        if runTaskCount == taskCount {
                            completion(.success(()))
                            semaphore.signal()
                        }
                    }
                })
            }
        }

        semaphore.wait()
    }
}
