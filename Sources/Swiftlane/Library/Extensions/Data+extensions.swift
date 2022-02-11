//
//  Data+extensions.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

extension Data {
    func toString() -> String {
        guard let output = String(data: self, encoding: .utf8) else {
            return ""
        }

        guard !output.hasSuffix("\n") else {
            let endIndex = output.index(before: output.endIndex)
            return String(output[..<endIndex])
        }

        return output

    }
}
