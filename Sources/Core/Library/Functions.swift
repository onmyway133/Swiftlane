//
//  Functions.swift
//  PumaCore
//
//  Created by khoa on 27/12/2019.
//

import Foundation

public func handleTryCatch(_ completion: TaskCompletion, _ job: () throws -> Void) {
    do {
        try job()
        completion(.success(()))
    } catch {
        completion(.failure(error))
    }
}
