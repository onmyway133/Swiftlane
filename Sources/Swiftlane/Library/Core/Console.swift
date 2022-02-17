//
//  Console.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct Console {
    func action(_ name: String) {
        let text = "[🚀 \(name)"
        print(text.foreground.Yellow.style.Bold)
    }

    func text(_ text: String) {
        print(text)
    }

    func success(_ text: String) {
        print("🎉 \(text)".foreground.Green)
    }

    func error(_ text: String) {
        print("❌ \(text)".foreground.Red)
    }

    func warn(_ text: String) {
        print("⚠️ \(text)".foreground.Magenta)
    }

    func newLine(_ n: Int = 1) {
        for _ in 0..<n {
            print("\n")
        }
    }

    func highlight(_ text: String) {
        print(text.foreground.Green)
    }
}
