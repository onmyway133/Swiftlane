//
//  Args.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct Args {
    private struct Pair {
        let key: String
        var value: String
    }

    private var pairs: [Pair] = []

    public subscript(_ key: String) -> String? {
        get {
            if let pair = pairs.first(where: { $0.key == key }) {
                return pair.value
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                if let index = pairs.firstIndex(where: { $0.key == key }) {
                    var pair = pairs[index]
                    pair.value = newValue
                    pairs[index] = pair
                } else {
                    let pair = Pair(key: key, value: newValue)
                    pairs.append(pair)
                }
            } else {
                pairs.removeAll(where: { $0.key == key })
            }
        }
    }

    public subscript(multiple key: String) -> String? {
        get {
            if let pair = pairs.first(where: { $0.key == key }) {
                return pair.value
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                let pair = Pair(key: key, value: newValue)
                pairs.append(pair)
            } else {
                pairs.removeAll(where: { $0.key == key })
            }
        }
    }

    public mutating func flag(_ key: String) {
        self[key] = ""
    }

    func toString() -> String {
        pairs
            .map { pair in
                let key = pair.key
                let value = pair.value

                if value.hasPrefix("=") {
                    return "\(key)\(value)" // key=value
                } else if value.isEmpty {
                    return "\(key)" // key
                } else {
                    return "\(key) \(value)" // key value
                }
            }
            .joined(separator: " ")
    }
}

