//
//  Log.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation
import Colorizer

public struct Log {
    public static func task(_ string: String) {
        print(String(repeating: "=", count: 60).foreground.Cyan)
        print("🚀 Running task \(string)".style.Bold.foreground.Cyan)
        print(String(repeating: "=", count: 60).foreground.Cyan)
    }
    
    public static func beforeSummary(_ string: String) {
        print(String(repeating: "=", count: 60).foreground.Yellow)
        print("⛵️ \(string)".style.Bold.foreground.Yellow)
        print(String(repeating: "=", count: 60).foreground.Yellow)
    }
    
    public static func afterSummary(_ string: String) {
        print(String(repeating: "=", count: 60).foreground.Green)
        print("🛳  \(string)".style.Bold.foreground.Green)
        print(String(repeating: "=", count: 60).foreground.Green)
    }

    public static func command(_ string: String) {
        print("👉 \(string)".foreground.Yellow)
    }
    
    public static func plain(_ string: String) {
        print(string)
    }
    
    public static func error(_ string: String) {
        print("❌ Error \(string)".foreground.Red)
    }
    
    public static func newLine() {
        print("\n")
    }
    
    public static func thank(_ string: String) {
        print("❤️  \(string)".foreground.Cyan)
    }
}
