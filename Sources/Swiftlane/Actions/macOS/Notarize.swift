//
//  Notarize.swift
//  Swiftlane
//
//  Created by khoa on 12/02/2022.
//

import Foundation
import SwiftyXMLParser

public final class Notarize: UseALTool {
    public var args = Args()

    public init() {}

    public func credential(
        username: String,
        password: String
    ) {
        args["--username"] = username
        args["--password"] = password
    }
}

public extension Notarize {
    func notarize(
        packageFile: URL,
        bundleId: String,
        ascProvider: String?
    ) async throws {
        Settings.cs.action("Notarize")

        var args = self.args
        args.flag("altool")
        args.flag("--notarize-app")
        args["-t"] = "osx"
        args["--output-format"] = "xml"
        args["--file"] = packageFile.path
        args["--primary-bundle-id"] = bundleId

        if let ascProvider = ascProvider {
            args["-asc-provider"] = ascProvider
        }

        let xmlString = try Settings.cli.run(
            program: "xcrun",
            argument: args.toString()
        )

        let uuid = try parseUUID(from: xmlString)
        let status = try await waitNotarization(uuid: uuid)

        switch status {
        case "success":
            Settings.cs.success("Notarize succeeded")
            try await staple(packageFile: packageFile)
        case "invalid":
            Settings.cs.error("Notarize failed")
            Settings.cs.highlight("UUID: \(uuid)")
            throw SwiftlaneError.invalid("notarize")
        default:
            throw SwiftlaneError.invalid("notarize")
        }
    }

    private func parseUUID(from xmlString: String) throws -> String {
        guard
            let xml = try? XML.parse(xmlString),
            let uuid = xml["plist", "dict", "dict", "string"].text
        else {
            throw SwiftlaneError.invalid("uuid")
        }

        return uuid
    }

    private func waitNotarization(uuid: String) async throws -> String {
        var status = ""
        while status.isEmpty || status == "in progress" {
            if status.isEmpty {
                Settings.cs.text("Checking status")
            } else {
                Settings.cs.text("Notarizing")
            }

            sleep(30)

            var info = ""
            do {
                info = try await fetchInfo(uuid: uuid)
            } catch {
                Settings.cs.error("Failed to get status")
            }

            if let s = parseStatus(xmlString: info) {
                status = s
            }
        }

        return status
    }

    private func fetchInfo(uuid: String) async throws -> String {
        var args = self.args
        args.flag("altool")
        args["--notarization-info"] = uuid
        args["-output-format"] = "xml"

        return try Settings.cli.run(
            program: "xcrun",
            argument: args.toString()
        )
    }

    private func parseStatus(xmlString: String) -> String? {
        guard
            let xml = try? XML.parse(xmlString),
            let items = xml["plist", "dict", "dict"].all
        else { return nil }

        for item in items.enumerated() {
            guard let text = item.element.text else { continue }
            if text == "Status",
               let status = items[item.offset + 1].text {
                return status
            } else {
                return nil
            }
        }

        return nil
    }

    private func staple(packageFile: URL) async throws {
        var args = Args()
        args.flag("stapler")
        args["staple"] = packageFile.path

        try Settings.cli.run(
            program: "xcrun",
            argument: args.toString()
        )
   }
}

