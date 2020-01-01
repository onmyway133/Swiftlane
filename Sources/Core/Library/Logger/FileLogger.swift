//
//  FileLogger.swift
//  Puma
//
//  Created by khoa on 01/01/2020.
//

import Foundation
import Files

public class FileLogger {
    public let saveFilePath: String
    private var loggedString = ""

    public init(saveFilePath: String) {
        self.saveFilePath = saveFilePath
    }
}

extension FileLogger: Logger {
    public func log(_ string: String) {
        print(string)
        loggedString.append(contentsOf: string)
    }

    public func finalize() throws {
        guard let data = loggedString.data(using: .utf8) else {
            throw PumaError.invalid
        }

        try File(path: saveFilePath).write(data: data)
        print("Logged file saved to: \(saveFilePath)")
    }
}
