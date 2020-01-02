//
//  XcodeBuildProcessHandler.swift
//  PumaiOS
//
//  Created by khoa on 02/12/2019.
//

import Foundation
import PumaCore
import XcbeautifyLib

public struct XcodeBuildProcessHandler: ProcessHandler {
    public let logger: Logger

    public init(logger: Logger = Console()) {
        self.logger = logger
    }

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

        logger.text(line)
    }
}
