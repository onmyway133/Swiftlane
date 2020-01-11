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
    public var workingDirectory: String = "."
    public let tasks: [Task]

    public lazy var summarizer = Summarizer(logger: logger)
    public var logger: Logger = Console()

    required public init(tasks: [Task] = []) {
        self.tasks = tasks
    }

    convenience public init(@TaskBuilder builder: () -> [Task]) {
        self.init(tasks: builder())
    }

    convenience public init(@TaskBuilder builder: () -> Task) {
        self.init(tasks: [builder()])
    }

    public func run(completion: @escaping TaskCompletion = { _ in }) {
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

    public func handle(error: Error) {
        guard let pumaError = error as? PumaError else {
            logger.error(error.localizedDescription)
            return
        }

        switch pumaError {
        case .process(let terminationStatus, let output, let error):
            let _ = output
            logger.error("code \(terminationStatus)")
            logger.error(error)
        default:
            logger.error(error.localizedDescription)
        }
    }
}
