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

    func hasPattern(_ pattern: String) throws -> Bool {
        let regex = try NSRegularExpression(pattern: pattern)
        return regex.firstMatch(
            in: self,
            options: [],
            range: NSRange(self.startIndex..., in: self)
        ) != nil
    }
}
