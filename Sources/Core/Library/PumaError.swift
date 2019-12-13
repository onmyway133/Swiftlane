//
//  PumaError.swift
//  Puma
//
//  Created by khoa on 15/04/2019.
//

import Foundation

public enum PumaError: Error {
    case unknown
    case invalid
    case validate(String)
    case process(terminationStatus: Int32, output: String, error: String)
}
