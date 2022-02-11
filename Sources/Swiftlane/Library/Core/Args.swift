//
//  Args.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct Args {
    private var map: [String: String] = [:]
    private var mapMultiple: [String: Set<String>] = [:]

    public subscript(_ key: String) -> String? {
        get {
            map[key]
        }
        set {
            map[key] = newValue
        }
    }

    public subscript(multiple key: String) -> String? {
        get {
            if let set = mapMultiple[key] {
                return set.map { $0 }.joined(separator: " ")
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue {
                var set = mapMultiple[key] ?? Set<String>()
                set.insert(newValue)
                mapMultiple[key] = set
            }
        }
    }

    func toString() -> String {
        let mapString = map
            .map { key, value in
                if value.hasPrefix("=") {
                    return "\(key)\(value)" // key=value
                } else if value.isEmpty {
                    return "\(key)" // key
                } else {
                    return "\(key) \(value)" // key value
                }
            }
            .sorted(by: <)
            .joined(separator: " ")

        let mapMultipleString = mapMultiple
            .compactMap { key, set in
                guard !set.isEmpty else { return nil }

                return set
                    .map { (value: String) -> String in
                        if value.hasPrefix("=") {
                            return "\(key)\(value)" // key=value
                        } else {
                            return "\(key) \(value)" // key value
                        }
                    }
                    .sorted(by: <)
                    .joined(separator: " ")
            }
            .sorted(by: <)
            .joined(separator: " ")

        return [mapString, mapMultipleString].joined(separator: " ")
    }
}
