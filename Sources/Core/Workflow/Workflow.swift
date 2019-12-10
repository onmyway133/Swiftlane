//
//  Workflow.swift
//  Colorizer
//
//  Created by khoa on 01/12/2019.
//

import Foundation
import Combine

/// Workflow is a group of tasks
public class Workflow {
    public let name: String
    public var workingDirectory: URL = URL(fileURLWithPath: ".")
    public let tasks: [Task]

    private let beforeSummarizer = BeforeSummarizer()
    private let afterSummarizer = AfterSummerizer()

    public init(name: String, @TaskBuilder builder: () -> [Task]) {
        self.name = name
        self.tasks = builder()
    }

    public init(name: String, @TaskBuilder builder: () -> Task) {
        self.name = name
        self.tasks = [builder()]
    }

    public func run(completion: WorkflowCompletion = { _ in }) {
        beforeSummarizer.on(tasks: tasks)
        runFirst(tasks: tasks, workflowCompletion: completion)
    }

    public func handle(error: Error) {
        guard let pumaError = error as? PumaError else {
            Deps.console.error(error.localizedDescription)
            return
        }

        switch pumaError {
        case .process(let terminationStatus, let output, let error):
            let _ = output
            Deps.console.error("code \(terminationStatus)")
            Deps.console.error(error)
        default:
            Deps.console.error(error.localizedDescription)
        }
    }

    private func runFirst(tasks: [Task], workflowCompletion: WorkflowCompletion) {
        guard let first = tasks.first else {
            Deps.console.newLine()
            afterSummarizer.show()
            workflowCompletion(.success(()))
            return
        }

        afterSummarizer.beforeRun(name: first.name)
        Deps.console.newLine()
        Deps.console.task(first.name)

        first.run(workflow: self, completion: { result in
            afterSummarizer.afterRun()

            switch result {
            case .success:
                var tasks = tasks
                tasks.removeFirst()
                self.runFirst(tasks: tasks, workflowCompletion: workflowCompletion)
            case .failure(let error):
                self.handle(error: error)
                workflowCompletion(.failure(error))
            }
        })
    }
}
