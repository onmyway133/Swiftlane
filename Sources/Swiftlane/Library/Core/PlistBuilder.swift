//
//  Plist.swift
//  Swiftlane
//
//  Created by khoa on 13/02/2022.
//

import Foundation

struct PlistBuilder {
    let dict: PlistDict

    func toString() -> String {
        let content = dict.toLines().joined(separator: "\n")
        return
"""
<?Plist version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
\(content)
</plist>
"""
    }
}

protocol PlistNode {
    func toLines() -> [String]
}

struct PlistString: PlistNode {
    let key: String
    let value: String

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    func toLines() -> [String] {
        [
            "<key>\(key)</key>",
            "<string>\(value)</string>"
        ]
    }
}

struct PlistBool: PlistNode {
    let key: String
    let value: Bool

    init(key: String, value: Bool) {
        self.key = key
        self.value = value
    }

    func toLines() -> [String] {
        let string = value ? "<true/>" : "<false/>"
        return [
            "<key>\(key)</key>",
            "\(string)"
        ]
    }
}

struct PlistDict: PlistNode {
    var key: String?
    var nodes: [PlistNode]

    func toLines() -> [String] {
        var lines = [String]()
        if let key = key {
            lines.append("<key>\(key)</key>")
        }

        lines.append("<dict>")
        lines.append(
            contentsOf: nodes
                .flatMap { $0.toLines() }
                .map { Array(repeating: " ", count: 4) + $0 }
        )
        lines.append("</dict>")

        return lines
    }
}
