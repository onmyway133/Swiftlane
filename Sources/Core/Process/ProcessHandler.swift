//
//  ProcessHandler.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

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
        let text = data.normalizeString()
        if !text.isEmpty {
            Deps.console.text(text)
        }
    }
}
