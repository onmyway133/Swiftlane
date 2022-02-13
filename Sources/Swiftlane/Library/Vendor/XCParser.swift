//
//  XCPParser.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/8/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import TSCBasic
import TSCUtility
import XCParseCore

let xcparseCurrentVersion = Version(2, 2, 1)

struct XCResultToolCompatability {
    var supportsExport: Bool = true
    var supportsUnicodeExportPaths: Bool = true // See https://github.com/ChargePoint/xcparse/issues/30
}

struct AttachmentExportOptions {
    var addTestScreenshotsDirectory: Bool = false
    var divideByTargetModel: Bool = false
    var divideByTargetOS: Bool = false
    var divideByTestPlanConfig: Bool = false
    var divideByLanguage: Bool = false
    var divideByRegion: Bool = false
    var divideByTest: Bool = false

    var xcresulttoolCompatability = XCResultToolCompatability()

    var testSummaryFilter: (ActionTestSummary) -> Bool = { _ in
        return true
    }
    var activitySummaryFilter: (ActionTestActivitySummary) -> Bool = { _ in
        return true
    }
    var attachmentFilter: (ActionTestAttachment) -> Bool = { _ in
        return true
    }

    func baseScreenshotDirectoryURL(path: String) -> Foundation.URL {
        let destinationURL = URL.init(fileURLWithPath: path)
        if self.addTestScreenshotsDirectory {
            return destinationURL.appendingPathComponent("testScreenshots")
        } else {
            return destinationURL
        }
    }

    func screenshotDirectoryURL(_ deviceRecord: ActionDeviceRecord, forBaseURL baseURL: Foundation.URL) -> Foundation.URL {
        var targetDeviceFolderName: String? = nil

        var modelName = deviceRecord.modelName
        if self.xcresulttoolCompatability.supportsUnicodeExportPaths != true, modelName == "iPhone Xʀ" {
            // For explaination, see https://github.com/ChargePoint/xcparse/issues/30
            modelName = "iPhone XR"
        }

        if self.divideByTargetModel == true, self.divideByTargetOS == true {
            targetDeviceFolderName = modelName + " (\(deviceRecord.operatingSystemVersion))"
        } else if self.divideByTargetModel {
            targetDeviceFolderName = modelName
        } else if self.divideByTargetOS {
            targetDeviceFolderName = deviceRecord.operatingSystemVersion
        }

        if let folderName = targetDeviceFolderName {
            if self.xcresulttoolCompatability.supportsUnicodeExportPaths != true {
                let asciiFolderName = folderName.lossyASCIIString() ?? folderName
                return baseURL.appendingPathComponent(asciiFolderName, isDirectory: true)
            } else {
                return baseURL.appendingPathComponent(folderName, isDirectory: true)
            }
        } else {
            return baseURL
        }
    }

    func screenshotDirectoryURL(_ testPlanRun: ActionTestPlanRunSummary, forBaseURL baseURL: Foundation.URL) -> Foundation.URL {
        guard let testPlanRunName = testPlanRun.name else {
            return baseURL
        }

        if self.divideByTestPlanConfig {
            if self.xcresulttoolCompatability.supportsUnicodeExportPaths != true {
                let asciiTestPlanRunName = testPlanRunName.lossyASCIIString() ?? testPlanRunName
                return baseURL.appendingPathComponent(asciiTestPlanRunName, isDirectory: true)
            } else {
                return baseURL.appendingPathComponent(testPlanRunName, isDirectory: true)
            }
        } else {
            return baseURL
        }
    }

    func screenshotDirectoryURL(_ testableSummary: ActionTestableSummary, forBaseURL baseURL: Foundation.URL) -> Foundation.URL {
        var languageRegionDirectoryName: String? = nil

        let testLanguage = testableSummary.testLanguage ?? "System Language"
        let testRegion = testableSummary.testRegion ?? "System Region"
        if self.divideByLanguage == true, self.divideByRegion == true {
            languageRegionDirectoryName = "\(testLanguage) (\(testRegion))"
        } else if self.divideByLanguage == true {
            languageRegionDirectoryName = testLanguage
        } else if self.divideByRegion == true {
            languageRegionDirectoryName = testRegion
        }

        if let folderName = languageRegionDirectoryName {
            if self.xcresulttoolCompatability.supportsUnicodeExportPaths != true {
                let asciiFolderName = folderName.lossyASCIIString() ?? folderName
                return baseURL.appendingPathComponent(asciiFolderName, isDirectory: true)
            } else {
                return baseURL.appendingPathComponent(folderName, isDirectory: true)
            }
        } else {
            return baseURL
        }
    }

    func screenshotDirectoryURL(_ testSummary: ActionTestSummary, forBaseURL baseURL: Foundation.URL) -> Foundation.URL {
        guard let summaryIdentifier = testSummary.identifier else {
            return baseURL
        }

        if self.divideByTest == true {
            if self.xcresulttoolCompatability.supportsUnicodeExportPaths != true {
                let asciiSummaryIdentifier = summaryIdentifier.lossyASCIIString() ?? summaryIdentifier
                return baseURL.appendingPathComponent(asciiSummaryIdentifier, isDirectory: true)
            } else {
                return baseURL.appendingPathComponent(summaryIdentifier, isDirectory: true)
            }
        } else {
            return baseURL
        }
    }
}

class XCPParser {
    var xcparseLatestVersion = xcparseCurrentVersion

    var console = XCParseCore.Console()
    let decoder = JSONDecoder()

    // MARK: -
    // MARK: Parsing Actions
    func checkXCResultToolCompatability(destination: String) -> XCResultToolCompatability {
        var compatability = XCResultToolCompatability()

        guard let xcresulttoolVersion = Version.xcresulttool() else {
            self.console.writeMessage("Warning: Could not determine xcresulttool version", to: .standard)
            return compatability
        }

        let unicodeExport = Version.xcresulttoolCompatibleWithUnicodeExportPath()
        if xcresulttoolVersion < unicodeExport  {
            // For explaination, see https://github.com/ChargePoint/xcparse/issues/30
            let asciiDestinationPath = destination.lossyASCIIString() ?? destination
            if asciiDestinationPath != destination {
                self.console.writeMessage("\nYour xcresulttool version \(xcresulttoolVersion.major) does not fully support Unicode export directory paths. Upgrade to Xcode 11.2.1 (xcresulttool version \(unicodeExport.major)) in order to export to your non-ASCII destination path.\n", to: .standard)

                compatability.supportsExport = false
                compatability.supportsUnicodeExportPaths = false
            } else {
                self.console.writeMessage("\nYour xcresulttool version \(xcresulttoolVersion.major) does not fully support Unicode export directory paths. Upgrade to Xcode 11.2.1 (xcresulttool version \(unicodeExport.major)) or above if you use non-Latin characters in your test run configuration names, attachment file names, or file system folder names.\n", to: .standard)

                compatability.supportsUnicodeExportPaths = false
            }
        }

        return compatability
    }

    func extractAttachments(xcresultPath: String, destination: String, options: AttachmentExportOptions = AttachmentExportOptions()) throws {
        // Check the xcresulttool version is compatible to export the request
        if options.xcresulttoolCompatability.supportsExport != true {
            return
        }

        var xcresult = XCResult(path: xcresultPath, console: self.console)
        guard let invocationRecord = xcresult.invocationRecord else {
            xcresult.console.writeMessage("“\(xcresult.path)” does not appear to be an xcresult", to: .error)
            return
        }

        // Let's figure out where these attachments are going
        let screenshotBaseDirectoryURL = options.baseScreenshotDirectoryURL(path: destination)
        if screenshotBaseDirectoryURL.createDirectoryIfNecessary() != true {
            return
        }

        // This is going to be the mapping of the places we're going to export the screenshots to
        var exportURLsToAttachments: [String : [ActionTestAttachment]] = [:]

        let actions = invocationRecord.actions.filter { $0.actionResult.testsRef != nil }
        for action in actions {
            guard let testRef = action.actionResult.testsRef else {
                continue
            }

            let targetDeviceRecord = action.runDestination.targetDeviceRecord

            // Determine name for the directory & make the directory if necessary
            let actionScreenshotDirectoryURL = options.screenshotDirectoryURL(targetDeviceRecord, forBaseURL: screenshotBaseDirectoryURL)
            if actionScreenshotDirectoryURL.createDirectoryIfNecessary() != true {
                continue
            }

            // Let's figure out the attachments to export
            guard let testPlanRunSummaries: ActionTestPlanRunSummaries = testRef.modelFromReference(withXCResult: xcresult) else {
                xcresult.console.writeMessage("Error: Unhandled test reference type \(String(describing: testRef.targetType?.getType()))", to: .error)
                continue
            }

            for testPlanRun in testPlanRunSummaries.summaries {
                let testPlanRunScreenshotURL = options.screenshotDirectoryURL(testPlanRun, forBaseURL: actionScreenshotDirectoryURL)
                if testPlanRunScreenshotURL.createDirectoryIfNecessary() != true {
                    continue
                }

                let testableSummaries = testPlanRun.testableSummaries
                for testableSummary in testableSummaries {
                    let testableSummaryScreenshotDirectoryURL = options.screenshotDirectoryURL(testableSummary, forBaseURL: testPlanRunScreenshotURL)
                    if testableSummaryScreenshotDirectoryURL.createDirectoryIfNecessary() != true {
                        continue
                    }

                    let testableSummariesToTestActivity = testableSummary.flattenedTestSummaryMap(withXCResult: xcresult)
                    for (testSummary, childActivitySummaries) in testableSummariesToTestActivity {
                        if options.testSummaryFilter(testSummary) == false {
                            continue
                        }

                        let filteredChildActivities = childActivitySummaries.filter(options.activitySummaryFilter)
                        let filteredAttachments = filteredChildActivities.flatMap { $0.attachments.filter(options.attachmentFilter) }

                        let testSummaryScreenshotURL = options.screenshotDirectoryURL(testSummary, forBaseURL: testableSummaryScreenshotDirectoryURL)
                        if testSummaryScreenshotURL.createDirectoryIfNecessary(createIntermediates: true) != true {
                            continue
                        }

                        // Now that we know what we want to export, save it to the dictionary so we can have all the exports
                        // done at once with one progress bar per URL
                        var existingAttachmentsForURL = exportURLsToAttachments[testSummaryScreenshotURL.path] ?? []
                        existingAttachmentsForURL.append(contentsOf: filteredAttachments)
                        exportURLsToAttachments[testSummaryScreenshotURL.path] = existingAttachmentsForURL
                    }

                }
            }
        }

        // Let's get ready to export!
        for (exportURLString, attachmentsToExport) in exportURLsToAttachments.sorted(by: { $0.key < $1.key }) {
            let exportURL = Foundation.URL(fileURLWithPath: exportURLString)
            if attachmentsToExport.count <= 0 {
                continue
            }

            let exportRelativePath = exportURL.path.replacingOccurrences(of: screenshotBaseDirectoryURL.path, with: "").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            let displayName = exportRelativePath.replacingOccurrences(of: "/", with: " - ")

            self.exportAttachments(withXCResult: xcresult, toDirectory: exportURL, attachments: attachmentsToExport, displayName: displayName)
        }
    }

    func exportAttachments(withXCResult xcresult: XCResult, toDirectory screenshotDirectoryURL: Foundation.URL, attachments: [ActionTestAttachment], displayName: String = "") {
        if attachments.count <= 0 {
            return
        }

        let header = (displayName != "") ? "Exporting \"\(displayName)\" Attachments" : "Exporting Attachments"
        let progressBar = PercentProgressAnimation(stream: TSCBasic.stdoutStream, header: header)
        progressBar.update(step: 0, total: attachments.count, text: "")

        for (index, attachment) in attachments.enumerated() {
            progressBar.update(step: index, total: attachments.count, text: "Extracting \"\(attachment.filename ?? "Unknown Filename")\"")

            XCResultToolCommand.Export(withXCResult: xcresult, attachment: attachment, outputPath: screenshotDirectoryURL.path).run()
        }

        progressBar.update(step: attachments.count, total: attachments.count, text: "🎊 Export complete! 🎊")
        progressBar.complete(success: true)
    }

    func extractCoverage(xcresultPath : String, destination : String) throws {
        var xcresult = XCResult(path: xcresultPath, console: self.console)
        guard let invocationRecord = xcresult.invocationRecord else {
            xcresult.console.writeMessage("“\(xcresult.path)” does not appear to be an xcresult", to: .error)
            return
        }

        // Let's make sure the destinations is available
        let destinationURL = URL.init(fileURLWithPath: destination)
        if destinationURL.createDirectoryIfNecessary() != true {
            return
        }

        var coverageReferenceIDs: [String] = []
        var coverageArchiveIDs: [String] = []

        for action in invocationRecord.actions {
            if let reportRef = action.actionResult.coverage.reportRef {
                coverageReferenceIDs.append(reportRef.id)
            }
            if let archiveRef = action.actionResult.coverage.archiveRef {
                coverageArchiveIDs.append(archiveRef.id)
            }
        }
        for (reportId, archiveId) in zip(coverageReferenceIDs, coverageArchiveIDs) {
            XCResultToolCommand.Export(withXCResult: xcresult, id: reportId,
                                        outputPath: "\(destination)/action.xccovreport",
                                        type: .file).run()
            XCResultToolCommand.Export(withXCResult: xcresult, id: archiveId,
                                        outputPath: "\(destination)/action.xccovarchive",
                                        type: .directory).run()
        }
    }

    func extractLogs(xcresultPath : String, destination : String) throws {
        var xcresult = XCResult(path: xcresultPath, console: self.console)
        guard let invocationRecord = xcresult.invocationRecord else {
            xcresult.console.writeMessage("“\(xcresult.path)” does not appear to be an xcresult", to: .error)
            return
        }

        let xcresulttoolCompatability = self.checkXCResultToolCompatability(destination: destination)
        if xcresulttoolCompatability.supportsExport != true {
            return
        }

        // Let's make sure the destinations is available
        let destinationURL = URL.init(fileURLWithPath: destination)
        if destinationURL.createDirectoryIfNecessary() != true {
            return
        }

        for (index, actionRecord) in invocationRecord.actions.enumerated() {
            let actionRecordDestinationURL = destinationURL.appendingPathComponent("\(index + 1)_\(actionRecord.schemeCommandName)")
            if actionRecordDestinationURL.createDirectoryIfNecessary(createIntermediates: false, console: self.console) != true {
                return
            }

            if let buildDiagnosticsRef = actionRecord.buildResult.diagnosticsRef {
                let buildDiagnosticsURL = actionRecordDestinationURL.appendingPathComponent("Diagnostics")
                XCResultToolCommand.Export(withXCResult: xcresult, id: buildDiagnosticsRef.id, outputPath: buildDiagnosticsURL.path, type: .directory).run()
            }

            if let actionDiagnosticsRef = actionRecord.actionResult.diagnosticsRef {
                let actionDiagnosticsURL = actionRecordDestinationURL.appendingPathComponent("Diagnostics")
                XCResultToolCommand.Export(withXCResult: xcresult, id: actionDiagnosticsRef.id, outputPath: actionDiagnosticsURL.path, type: .directory).run()
            }

            // TODO: Alex - note that these aren't actually log files but ActivityLogSection objects. User from StackOverflow was just exporting those
            // out as text files as for the most party they can be human readable, but it won't match what Xcode exports if you open the XCResult
            // and attempt to export out the log. That seems like it may involve having to create our own pretty printer similar to Xcode's to export
            // the ActivityLogSection into a nicely human readable text file.
            //
            // Also note either we missed in formatDescription objects like ActivityLogCommandInvocationSection or Apple added them in later betas. We'll
            // need to add parsing, using the same style we do for ActionTestSummaryIdentifiableObject subclasses
            if let buildResultLogRef = actionRecord.buildResult.logRef {
//                let activityLogSectionJSON = XCResultToolCommand.Get(withXCResult: xcresult, id: buildResultLogRef.id, outputPath: "", format: .json).run()
//                let activityLogSection = try decoder.decode(ActivityLogSection.self, from: Data(activityLogSectionJSON.utf8))
                let buildLogURL = actionRecordDestinationURL.appendingPathComponent("build.txt")
                XCResultToolCommand.Export(withXCResult: xcresult, id: buildResultLogRef.id, outputPath: buildLogURL.path, type: .file).run()
            }

            if let actionResultLogRef = actionRecord.actionResult.logRef {
//                let activityLogSectionJSON = XCResultToolCommand.Get(withXCResult: xcresult, id: actionResultLogRef.id, outputPath: "", format: .json).run()
//                let activityLogSection = try decoder.decode(ActivityLogSection.self, from: Data(activityLogSectionJSON.utf8))
                let actionLogURL = actionRecordDestinationURL.appendingPathComponent("action.txt")
                XCResultToolCommand.Export(withXCResult: xcresult, id: actionResultLogRef.id, outputPath: actionLogURL.path, type: .file).run()
            }
        }
    }
}
