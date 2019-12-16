//
//  Array+Extensions.swift
//  PumaCore
//
//  Created by khoa on 01/12/2019.
//

import Foundation

public extension Array where Element: Hashable {
    var removingDuplicates: Array {
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
    func removingFirst() -> Array {
        var array = self
        array.removeFirst()
        return array
    }
}

public extension Array where Element == String {
    func contains(prefix: String) -> Bool {
        return first(where: { $0.hasPrefix(prefix) }) != nil
    }

    mutating func replace(containingPrefix prefix: String, with string: String) {
        guard let index = firstIndex(where: { $0.hasPrefix(prefix) }) else {
            return
        }

        self.remove(at: index)
        self.append("\(prefix) \(string)")
    }
}
