//
//  Optional+Extensions.swift
//  Puma
//
//  Created by khoa on 17/12/2019.
//

import Foundation

public extension Optional {
    func unwrapOrThrow(_ error: Error) throws -> Wrapped {
        if let value = self {
            return value
        } else {
            throw error
        }
    }
}
