//
//  XcodeBuildProcessHandler.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation
import XcbeautifyLib

public struct XcodeBuildProcessHandler: ProcessHandler {
    public func handle(output data: Data) {
        show(data: data)
    }

    public func handle(error data: Data) {
        show(data: data)
    }

    private func show(data: Data) {
        let parser = XcbeautifyLib.Parser(renderer: .terminal, additionalLines: { nil })
        guard
            !data.isEmpty,
            let line = parser.parse(line: data.toString()),
            !line.isEmpty
        else {
            return
        }

        Settings.cs.text(line)
    }
}
