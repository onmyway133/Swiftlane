//
//  Workflow.swift
//  Colorizer
//
//  Created by khoa on 01/12/2019.
//

import Foundation

/// Workflow is a group of tasks
public class Workflow {
    public var name: String = "Workflow"

    public private(set) var workingDirectory: String = "."
    public private(set) lazy var summarizer = Summarizer(logger: logger)
    public private(set) var logger: Logger = Console()

    private let tasks: [Task]

    required public init(tasks: [Task] = []) {
        self.tasks = tasks
    }

    convenience public init(@TaskBuilder builder: () -> [Task]) {
        self.init(tasks: builder())
    }

    convenience public init(@TaskBuilder builder: () -> Task) {
        self.init(tasks: [builder()])
    }
}

public extension Workflow {
    func logger(_ logger: Logger) -> Self {
        self.logger = logger
        return self
    }

    func workingDirectory(_ workingDirectory: String) -> Self {
        self.workingDirectory = workingDirectory
        return self
    }
}

public extension Workflow
{
    func run(completion: @escaping TaskCompletion = { _ in }) {
        summarizer.update(tasks: tasks)
        summarizer.showTasks()

        Sequence(tasks: tasks).run(workflow: self, completion: { result in
            switch result {
            case .success:
                self.summarizer.showSummary()
                completion(.success(()))
            case .failure(let error):
                self.handle(error: error)
                self.summarizer.showSummary()
                completion(.failure(error))
            }

            try? self.logger.finalize()
        })
    }

    private func handle(error: Error) {
        switch error {
        case PumaError.process(let terminationStatus, _, let error):
            logger.error("code \(terminationStatus)")
            logger.error(error)

        default:
            logger.error(error.localizedDescription)
        }
    }
}
