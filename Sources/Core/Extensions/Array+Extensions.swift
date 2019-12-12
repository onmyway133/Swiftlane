//
//  Array+Extensions.swift
//  PumaCore
//
//  Created by khoa on 01/12/2019.
//

import Foundation

public extension Array where Element: Hashable {
    var removeDuplicates: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

    mutating func remove(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
}

public extension Array {
    func firstRemoved() -> Array {
        var array = self
        array.removeFirst()
        return array
    }
}
