//
//  Xml.swift
//  PumaCore
//
//  Created by khoa on 28/12/2019.
//

import Foundation

public protocol XmlItem {
    func toLines() -> [String]
}

public struct XmlString: XmlItem {
    public let key: String
    public let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    public func toLines() -> [String] {
        return [
            "<key>\(key)</key>",
            "<string>\(value)</string>"
        ] as [String]
    }
}

public struct XmlBool: XmlItem {
    public let key: String
    public let value: Bool

    public init(key: String, value: Bool) {
        self.key = key
        self.value = value
    }

    public func toLines() -> [String] {
        let string = value ? "<true/>" : "<false/>"
        return [
            "<key>\(key)</key>",
            "\(string)"
        ] as [String]
    }
}

public struct XmlDict: XmlItem {
    public let key: String
    public let items: [XmlItem]

    public init(key: String, items: [XmlItem]) {
        self.key = key
        self.items = items
    }

    public func toLines() -> [String] {
        var lines = [String]()
        lines.append("<dict>")
        lines.append(contentsOf: items.flatMap({ $0.toLines() }))
        lines.append("</dict>")

        return lines
    }
}

public class XmlGenerator {
    public init() {}
    public func generateXml(_ items: [XmlItem]) -> String {
        let content = items.flatMap({ $0.toLines() }).joined(separator: "\n")
        let xml =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        \(content)
        </dict>
        </plist>
        """
        return xml
    }
}
