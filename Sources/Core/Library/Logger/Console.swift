//
//  Console.swift
//  Puma
//
//  Created by khoa on 30/11/2019.
//

import Foundation

public class Console: Logger {
    public init() {}

    public func log(_ string: String) {
        print(string)
    }

    public func finalize() throws {
        // No op
    }
}
