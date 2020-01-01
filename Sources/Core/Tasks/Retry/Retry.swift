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

    private var task: Task?
    private var times: UInt = 0

    public init(_ closure: (Retry) -> Void = { _ in }) {
        closure(self)
    }
}

extension Retry: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        guard let task = task else {
            completion(.failure(PumaError.invalid))
            return
        }

        run(task: task, times: times, workflow: workflow, completion: completion)
    }

    private func run(task: Task, times: UInt, workflow: Workflow, completion: @escaping TaskCompletion) {
        task.run(workflow: workflow, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                if times > 0 {
                    self.run(task: task, times: times - 1, workflow: workflow, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        })
    }
}

public extension Retry {
    func retry(task: Task, times: UInt) {
        self.task = task
        self.times = times
    }
}
