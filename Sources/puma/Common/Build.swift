//
//  Command.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public func buildCommand(_ command: String, extend: String) -> String {
    if !extend.isEmpty {
        return command + " " + extend
    } else {
        return command
    }
}

public func buildArgument(_ arguments: [String: String?], extend: String = "") -> String {
    let string = arguments
        .compactMap({ key, value in
            guard let value = value else {
                return nil
            }
            
            return "\(key)\(value)"
        })
        .joined(separator: " ")
    
    if !extend.isEmpty {
        return string + " " + extend
    } else {
        return string
    }
}
