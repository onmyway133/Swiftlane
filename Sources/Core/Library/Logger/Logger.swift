//
//  Logger.swift
//  Puma
//
//  Created by khoa on 01/01/2020.
//

import Foundation
import Colorizer

public protocol Logger {
    func log(_ string: String)
    func finalize() throws
}

public extension Logger {
    func header(_ text: String) {
        log(String(repeating: "=", count: 60).foreground.Cyan)
        log(text.style.Bold.foreground.Yellow.style.Bold)
        log(String(repeating: "=", count: 60).foreground.Cyan)
    }

    func title(_ text: String) {
        log(text.foreground.Yellow.style.Bold)
    }

    func text(_ text: String) {
        log(text)
    }

    func error(_ text: String) {
        log("❌ \(text)".foreground.Red)
    }

    func success(_ text: String) {
        log("👍 \(text)".foreground.Green)
    }

    func warn(_ text: String) {
        log("⚠️ \(text)".foreground.Magenta)
    }

    func note(_ text: String) {
        log("👋 \(text)".foreground.Magenta)
    }

    func newLine() {
        log("\n")
    }

    func highlight(_ text: String) {
        log(text.foreground.Green)
    }
}
