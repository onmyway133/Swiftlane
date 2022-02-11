//
//  Process.swift
//  ProcessHandler
//
//  Created by Khoa on 11/02/2022.
//

import Foundation
import XcbeautifyLib

public protocol ProcessHandler {
    func handle(output data: Data)
    func handle(error data: Data)
}

public struct DefaultProcessHandler: ProcessHandler {
    public typealias Filter = (String) -> Bool

    public let filter: Filter

    public init(filter: @escaping Filter = { _ in true }) {
        self.filter = filter
    }

    public func handle(output data: Data) {
        show(data: data)
    }

    public func handle(error data: Data) {
        show(data: data)
    }

    private func show(data: Data) {
        let text = data.toString()
        if !text.isEmpty && filter(text) {
            Settings.default.cs.text(text)
        }
    }
}

