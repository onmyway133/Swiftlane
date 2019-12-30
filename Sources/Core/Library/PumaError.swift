//
//  PumaError.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public enum PumaError: Error {
    case invalid
    case string(String)
    case process(terminationStatus: Int32, output: String, error: String)

    static func from(string: String?) -> PumaError {
        if let string = string {
            return PumaError.string(string)
        } else {
            return PumaError.invalid
        }
    }
}
