//
//  SwiftlaneError.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public enum SwiftlaneError: Swift.Error {
    case invalid(String)
    case missingArgument(String)
    case process(terminationStatus: Int32, error: String)
}
