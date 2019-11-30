//
//  Data+Extensions.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

extension Data {
    func normalizeString() -> String {
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
