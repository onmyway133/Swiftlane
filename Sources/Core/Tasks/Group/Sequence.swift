//
//  Sequence.swift
//  Puma
//
//  Created by khoa on 12/12/2019.
//

import Foundation

/// Run tasks sequentially
public class Sequence: Task {
    public var name: String = "Sequence"
    public var isEnabled = true
    public let tasks: [Task]

    public init(tasks: [Task]) {
        self.tasks = tasks
    }

    public init(@TaskBuilder builder: () -> [Task]) {
        self.tasks = builder()
    }

    public init(@TaskBuilder builder: () -> Task) {
        self.tasks = [builder()]
    }

    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        let semaphore = DispatchSemaphore(value: 0)
        runFirst(tasks: tasks, workflow: workflow, completion: { result in
            completion(result)
            semaphore.signal()
        })

        semaphore.wait()
    }

    private func runFirst(tasks: [Task], workflow: Workflow, completion: @escaping TaskCompletion) {
        guard let first = tasks.first else {
            completion(.success(()))
            return
        }

        guard first.isEnabled else {
            self.runFirst(
                tasks: tasks.removingFirst(),
                workflow: workflow,
                completion: completion
            )

            return
        }

        workflow.logger.newLine()
        workflow.logger.title("🚀 \(first.name)")

        workflow.summarizer.track(task: first, startAt: Deps.date())
        first.run(workflow: workflow, completion: { result in
            workflow.summarizer.track(task: first, finishAt: Deps.date())

            switch result {
            case .success:
                self.runFirst(
                    tasks: tasks.removingFirst(),
                    workflow: workflow,
                    completion: completion
                )
            case .failure(let error):
                workflow.summarizer.track(task: first, error: error)
                completion(.failure(error))
            }
        })
    }
}
