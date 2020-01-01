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
    public typealias Filter = (String) -> Bool

    public let filter: Filter
    public let logger: Logger

    public init(logger: Logger = Console(), filter: @escaping Filter = { _ in true }) {
        self.filter = filter
        self.logger = logger
    }

    public func handle(output data: Data) {
        show(data: data)
    }
    
    public func handle(error data: Data) {
        show(data: data)
    }
    
    private func show(data: Data) {
        let text = data.normalizeString()
        if !text.isEmpty && filter(text) {
            logger.text(text)
        }
    }
}
