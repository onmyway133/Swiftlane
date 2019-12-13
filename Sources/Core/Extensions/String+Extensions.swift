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
}
