//
//  ProcessHandler.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation
import XcbeautifyLib

public protocol ProcessHandler {
    func handle(output data: Data)
    func handle(error data: Data)
}

public struct DefaultProcessHandler: ProcessHandler {
    public init() {}

    public func handle(output data: Data) {
        show(data: data)
    }
    
    public func handle(error data: Data) {
        show(data: data)
    }
    
    private func show(data: Data) {
        guard
            !data.isEmpty,
            let line = XcbeautifyLib.Parser().parse(line: data.normalizeString()),
            !line.isEmpty
            else {
                return
        }
        
        Deps.console.text(line)
    }
}
