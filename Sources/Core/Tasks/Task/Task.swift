//
//  Task.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public typealias TaskCompletion = (Result<(), Error>) -> Void

public protocol Task: AnyObject {
    var name: String { get }
    var isEnabled: Bool { get }
    func run(workflow: Workflow, completion: @escaping TaskCompletion)
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
