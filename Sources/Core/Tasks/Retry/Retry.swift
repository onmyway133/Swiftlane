//
//  Retry.swift
//  Puma
//
//  Created by khoa on 01/01/2020.
//

import Foundation

public class Retry {
    public var name: String = "Retry"
    public var isEnabled = true

    private let task: Task
    private let times: UInt

    public init(times: UInt, builder: () -> Task) {
        self.times = times
        self.task = builder()
    }
}

// MARK: - Task

extension Retry: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        run(task: task, times: times, workflow: workflow, completion: completion)
    }

    private func run(task: Task, times: UInt, workflow: Workflow, completion: @escaping TaskCompletion) {
        task.run(workflow: workflow, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                if times > 0 {
                    workflow.logger.log("Retry encountered an error and will retry for \(times-1) more time(s): \(error.localizedDescription)")
                    self.run(task: task, times: times - 1, workflow: workflow, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        })
    }
}
