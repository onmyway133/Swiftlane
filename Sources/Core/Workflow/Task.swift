//
//  Task.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation
import Combine

public protocol Task: AnyObject {
    var name: String { get }
    func run(workflow: Workflow, completion: TaskCompletion)
}

public extension Task {
    func asPublisher(workflow: Workflow) -> AnyPublisher<(), Error> {
        return Future({ completion in
            self.run(workflow: workflow, completion: completion)
        }).eraseToAnyPublisher()
    }

    func run(workflow: Workflow, completion: TaskCompletion, job: () throws -> Void) {
        do {
            try job()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
