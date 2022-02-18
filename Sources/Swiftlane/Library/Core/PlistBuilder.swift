//
//  Plist.swift
//  Swiftlane
//
//  Created by khoa on 13/02/2022.
//

import Foundation

struct PlistBuilder {
    func save<T: Encodable>(
        model: T,
        toFile: URL
    ) throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let data = try encoder.encode(model)
        try data.write(to: toFile)
    }
}

