//
//  String+Extensions.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public extension String {
    func containsIgnoringCase(_ find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func surroundingWithQuotes() -> String {
        return "'\(self)'"
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

// URL like
public extension String {
    func ensuringPathExtension(_ pathExtension: String, name: String) -> String {
        if hasPathExtension(pathExtension) {
            return self
        } else {
            return URL(fileURLWithPath: self).appendingPathComponent(name).appendingPathExtension(pathExtension).path
        }
    }

    func folderPath() -> String {
        return URL(fileURLWithPath: self).deletingLastPathComponent().path
    }

    func hasPathExtension(_ pathExtension: String) -> Bool {
        let url = URL(fileURLWithPath: self)
        return url.pathExtension == pathExtension
    }

    func lastPathComponent() -> String {
        return URL(fileURLWithPath: self).lastPathComponent
    }

    func appendingPathExtension(_ pathExtension: String) -> String {
        return URL(fileURLWithPath: self).appendingPathExtension(pathExtension).path
    }

    func deletingPathExtension(_ pathExtension: String) -> String {
        if hasPathExtension(pathExtension) {
            return URL(fileURLWithPath: pathExtension).deletingPathExtension().path
        } else {
            return self
        }
    }
}
