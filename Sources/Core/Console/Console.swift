//
//  Console.swift
//  PumaCore
//
//  Created by khoa on 30/11/2019.
//

import Foundation
import Colorizer

open class Console {
    public init() {}

    open func header(_ text: String) {
        print(String(repeating: "=", count: 60).foreground.Cyan)
        print(text.style.Bold.foreground.Yellow)
        print(String(repeating: "=", count: 60).foreground.Cyan)
    }

    open func title(_ text: String) {
        print(text.foreground.Yellow)
    }

    open func text(_ text: String) {
        print(text)
    }

    open func error(_ text: String) {
        print("❌ \(text)".foreground.Red)
    }

    open func newLine() {
        print("\n")
    }
}
