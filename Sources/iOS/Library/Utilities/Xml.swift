//
//  Xml.swift
//  PumaiOS
//
//  Created by khoa on 28/12/2019.
//

import Foundation

protocol XmlItem {
    func toLines() -> [String]
}

class Xml {
    struct Record: XmlItem {
        let key: String
        let value: String
        let type: String

        func toLines() -> [String] {
            return [
                "<key>\(key)</key>",
                "<\(type)>\(value)</\(type)>"
            ] as [String]
        }
    }

    struct Dict: XmlItem {
        let key: String
        let items: [XmlItem]

        func toLines() -> [String] {
            var lines = [String]()
            lines.append("<dict>")
            lines.append(contentsOf: items.flatMap({ $0.toLines() }))
            lines.append("</dict>")

            return lines
        }
    }
}

class XmlGenerator {
    func generateXml(_ items: [XmlItem]) -> String {
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
