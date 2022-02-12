//
//  CommandLine.swift
//  Swiftlane
//
//  Created by Khoa on 11/02/2022.
//

import Foundation

public struct CommandLine {
    @discardableResult
    func run(
        program: String,
        argument: String,
        currentDirectoryURL: URL? = nil,
        processHandler: ProcessHandler = DefaultProcessHandler()
    ) throws -> String {
        let command = "\(program) \(argument)"
        Settings.default.cs.highlight(command)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command]
        process.currentDirectoryURL = currentDirectoryURL

        return try run(
            process: process,
            processHandler: processHandler
        )
    }

    @discardableResult
    func run(
        process: Process,
        processHandler: ProcessHandler = DefaultProcessHandler()
    ) throws -> String {
        let outputQueue = DispatchQueue(label: "Process.Queue")

        var outputData = Data()
        var errorData = Data()

        let outputPipe = Pipe()
        process.standardOutput = outputPipe

        let errorPipe = Pipe()
        process.standardError = errorPipe

        #if !os(Linux)
        outputPipe.fileHandleForReading.readabilityHandler = { handler in
            outputQueue.async {
                let data = handler.availableData
                processHandler.handle(output: data)
                outputData.append(data)
            }
        }

        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            outputQueue.async {
                let data = handler.availableData
                processHandler.handle(error: data)
                errorData.append(data)
            }
        }
        #endif

        process.launch()

        #if os(Linux)
        outputQueue.sync {
            outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        }
        #endif

        process.waitUntilExit()

        #if !os(Linux)
        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        #endif

        // Block until all writes have occurred to outputData and errorData,
        // and then read the data back out.
        return try outputQueue.sync {
            if process.terminationStatus != 0 {
                throw SwiftlaneError.code(
                    process.terminationStatus,
                    error: errorData.toString()
                )
            }

            return outputData.toString()
        }
    }
}


