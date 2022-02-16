//
//  String.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

extension String {
    func surroundingWithQuotes() -> String {
        guard
            !hasPrefix("'"),
            !hasSuffix("'")
        else { return self }

        return "'\(self)'"
    }

    func appendingPathExtension(_ ext: String) -> String {
        guard !hasSuffix(ext) else {
            return self
        }

        return "\(self).\(ext)"
    }

    func deletingPathExtension(_ ext: String) -> String {
        guard hasSuffix(ext) else { return self }
        return replacingOccurrences(of: ".\(self)", with: "")
    }
}
