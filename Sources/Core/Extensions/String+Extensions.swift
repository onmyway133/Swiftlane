//
//  String+Extensions.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public extension String {
    func addingFileExtension(_ fileExtension: String) -> String {
        if contains(fileExtension) {
            return self
        } else {
            return "\(self).\(fileExtension)"
        }
    }

    func removingFileExtension(_ fileExtension: String) -> String {
        if contains(fileExtension) {
            return replacingOccurrences(of: ".\(fileExtension)", with: "")
        } else {
            return self
        }
    }
    
    func surroundingWithQuotes() -> String {
        return "'\(self)'"
    }

    func addingPath(_ name: String, fileExtension: String) -> String {
        let url = URL(fileURLWithPath: self)
        return url.appendingPathComponent(name).appendingPathExtension(fileExtension).path
    }

    func hasFileExtension(_ fileExtension: String) -> Bool {
        let url = URL(fileURLWithPath: self)
        return url.pathExtension == fileExtension
    }

    func matches(pattern: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: pattern)
        let results = regex.matches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
        return results.compactMap({ result in
            if let range = Range(result.range, in: self) {
                return String(self[range])
            } else {
                return nil
            }
        })
    }

    func hasPattern(pattern: String) throws -> Bool {
        return try !matches(pattern: pattern).isEmpty
    }
}
