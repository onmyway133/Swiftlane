//
//  Plist.swift
//  Swiftlane
//
//  Created by khoa on 13/02/2022.
//

import Foundation

@resultBuilder
enum PlistBuilder {
    static func buildBlock(_ components: PlistNode...) -> [PlistNode] {
        components
    }

    static func buildBlock(_ components: [PlistNode]...) -> [PlistNode] {
        components.flatMap { $0 }
    }


    static func buildEither(first component: [PlistNode]) -> [PlistNode] {
        component
    }

    static func buildEither(second component: [PlistNode]) -> [PlistNode] {
        component
    }

    static func buildOptional(_ component: [PlistNode]?) -> [PlistNode] {
        component ?? []
    }

    static func buildExpression(_ expression: PlistNode) -> [PlistNode] {
        [expression]
    }

    static func buildExpression(_ expression: [PlistNode]) -> [PlistNode] {
        expression
    }

    static func buildArray(_ components: [[PlistNode]]) -> [PlistNode] {
        components.flatMap { $0 }
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

    init(key: String? = nil, @PlistBuilder _ builder: () -> [PlistNode]) {
        self.key = key
        self.nodes = builder()
    }

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

    func toPlistString() -> String {
        let content = toLines().joined(separator: "\n")
        return
"""
<?Plist version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
\(content)
</plist>
"""
    }
}
