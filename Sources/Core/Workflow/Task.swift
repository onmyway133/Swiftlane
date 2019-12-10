//
//  Task.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public protocol Task: AnyObject {
    var name: String { get }
    var isEnabled: Bool { get set }
    func run(workflow: Workflow, completion: TaskCompletion)
}

public extension Task {
    func with(_ completion: TaskCompletion, _ job: () throws -> Void) {
        do {
            try job()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
