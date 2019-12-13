//
//  Xcodebuild.swift
//  PumaiOS
//
//  Created by khoa on 10/12/2019.
//

import Foundation

public struct Xcodebuild {
    var arguments: [String] = []
}

public extension Xcodebuild {
    mutating func project(_ name: String) {
        let normalizedName = name
            .addingFileExtension("xcodeproj")
            .surroundingWithQuotes()
        arguments.append("-project \(normalizedName)")
    }

    mutating func workspace(_ name: String) {
        let normalizedName = name
            .addingFileExtension("xcworkspace")
            .surroundingWithQuotes()

        arguments.append("-workspace \(normalizedName)")
    }

    mutating func scheme(_ name: String) {
        let normalizedName = name
            .surroundingWithQuotes()
        arguments.append("-scheme \(normalizedName)")
    }

    mutating func configuration(_ configuration: String) {
        arguments.append("-configuration \(configuration)")
    }

    mutating func sdk(_ sdk: String) {
        arguments.append("-sdk \(sdk)")
    }

    mutating func usesModernBuildSystem(enabled: Bool) {
        arguments.append("-UseModernBuildSystem=\(enabled ? "YES": "NO")")
    }

    mutating func destination(_ destination: Destination) {
        let string = destination
            .toString()
            .surroundingWithQuotes()
        arguments.append("-destination \(string)")
    }

    mutating func derivedDataPath(_ url: URL) {
        arguments.append("-derivedDataPath \(url.path)")
    }

    mutating func testPlan(_ url: URL) {
        let path = url.path.removingFileExtension("xctestplan")
        arguments.append("-testplan \(path)")
    }
}
