//
//  Process.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

// Based on https://github.com/JohnSundell/ShellOut

public extension Process {
    @discardableResult func run(
        command: String,
        processHandler: ProcessHandler = DefaultProcessHandler()) throws -> String {

        launchPath = "/bin/bash"
        arguments = ["-c", command]
        
        // Because FileHandle's readabilityHandler might be called from a
        // different queue from the calling queue, avoid a data race by
        // protecting reads and writes to outputData and errorData on
        // a single dispatch queue.
        let outputQueue = DispatchQueue(label: "bash-output-queue")
        
        var outputData = Data()
        var errorData = Data()
        
        let outputPipe = Pipe()
        standardOutput = outputPipe
        
        let errorPipe = Pipe()
        standardError = errorPipe
        
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
        
        launch()
        
        #if os(Linux)
        outputQueue.sync {
            outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        }
        #endif
        
        waitUntilExit()

        #if !os(Linux)
        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        #endif
        
        // Block until all writes have occurred to outputData and errorData,
        // and then read the data back out.
        return try outputQueue.sync {
            if terminationStatus != 0 {
                throw PumaError.process(
                    terminationStatus: terminationStatus,
                    output: outputData.normalizeString(),
                    error: errorData.normalizeString()
                )
            }
            
            return outputData.normalizeString()
        }
    }
}
