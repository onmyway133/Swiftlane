//
//  Notarize.swift
//  Swiftlane
//
//  Created by khoa on 12/02/2022.
//

import Foundation
import SWXMLHash

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
        Settings.default.cs.action("Notarize")

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

        let xmlString = try Settings.default.cli.run(
            program: "xcrun",
            argument: args.toString()
        )

        let uuid = try parseUUID(from: xmlString)
        let status = try await waitNotarization(uuid: uuid)

        switch status {
        case "success":
            Settings.default.cs.success("Notarize succeeded")
            try await staple(packageFile: packageFile)
        case "invalid":
            Settings.default.cs.error("Notarize failed")
            Settings.default.cs.highlight("UUID: \(uuid)")
            throw SwiftlaneError.invalid("notarize")
        default:
            throw SwiftlaneError.invalid("notarize")
        }
    }

    private func parseUUID(from xmlString: String) throws -> String {
        let xml = XMLHash.config { _ in }
            .parse(xmlString)

        guard let uuid = xml["plist"]["dict"]["dict"]["string"].element?.text
        else {
            throw SwiftlaneError.invalid("uuid")
        }

        return uuid
    }

    private func waitNotarization(uuid: String) async throws -> String {
        var status = ""
        while status.isEmpty || status == "in progress" {
            if status.isEmpty {
                Settings.default.cs.text("Checking status")
            } else {
                Settings.default.cs.text("Notarizing")
            }

            sleep(30)

            var info = ""
            do {
                info = try await fetchInfo(uuid: uuid)
            } catch {
                Settings.default.cs.error("Failed to get status")
            }

            if let s = parseStatus(info: info) {
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

        return try Settings.default.cli.run(
            program: "xcrun",
            argument: args.toString()
        )
    }

    private func parseStatus(info: String) -> String? {
        let xml = XMLHash.config { _ in }
            .parse(info)
        let items = xml["plist"]["dict"]["dict"].children

        for item in items.enumerated() {
            guard let text = item.element.element?.text else { continue }
            if text == "Status",
                let status = items[item.offset + 1].element?.text {
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

        try Settings.default.cli.run(
            program: "xcrun",
            argument: args.toString()
        )
   }
}

