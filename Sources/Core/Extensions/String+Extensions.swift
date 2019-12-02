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
        }
        
        return "\(self).\(fileExtension)"
    }
    
    func surroundingWithQuotes() -> String {
        return "'\(self)'"
    }
}
