//
//  Dictionary+Extensions.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public extension Dictionary {
    func simpleMerging(_ other: Dictionary?) -> Dictionary {
        guard let other = other else {
            return self
        }

        return merging(other, uniquingKeysWith: { (first, _) in first })
    }
}
