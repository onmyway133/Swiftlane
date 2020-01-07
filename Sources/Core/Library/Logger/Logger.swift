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
    func task(_ text: String) {
        let task = "[\(getFormattedDate())] 🚀 \(text)"
        log(task.foreground.Yellow.style.Bold)
    }
    
    func header(_ text: String) {
        log(String(repeating: "=", count: 60).foreground.Cyan)
        log(text.style.Bold.foreground.Yellow.style.Bold)
        log(String(repeating: "=", count: 60).foreground.Cyan)
    }

    func logo() {
        log(String(repeating: "=", count: 60).foreground.Cyan)
        let text = ConsoleArt.pumaLogoAscii
        log(text.style.Bold.foreground.Yellow.style.Bold)
    }
    
    func puma() {
        log(String(repeating: "=", count: 60).foreground.Cyan)
        let text = ConsoleArt.pumaTitleAscii
        log(text.style.Bold.foreground.Cyan.style.Bold)
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
    
    func newLines(_ n: Int) {
        for _ in 0..<n {
            log("\n")
        }
    }

    func highlight(_ text: String) {
        log(text.foreground.Green)
    }
    
    func getFormattedDate() -> String {
        let date = Date()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "HH:mm:ss"
        return dateformat.string(from: date)
    }

}
