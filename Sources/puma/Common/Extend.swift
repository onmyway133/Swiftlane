//
//  Extend.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct Extend {
    // -key1=value1 -key2 value2 --flag
    let argument: String
    
    // clean | xcpretty | echo
    let command: String
    
    public init(argument: String = "", command: String = "") {
        self.argument = argument
        self.command = command
    }
}
