//
//  AppStoreConnect.swift
//  Swiftlane
//
//  Created by khoa on 12/02/2022.
//

import AppStoreConnect
import Foundation

public struct ASC {
    public let client: AppStoreConnect.Client

    public init(credential: AppStoreConnect.Credential) throws {
        self.client = try AppStoreConnect.Client(credential: credential)
    }
}

public extension ASC {
    func fetchCertificates() async throws -> [Certificate] {
        let params = Paths.Certificates.GetParameters(
            filterCertificateType: nil,
            filterDisplayName: nil,
            filterSerialNumber: nil,
            filterID: nil,
            sort: nil,
            fieldsCertificates: nil,
            limit: nil
        )

        let request = Paths.certificates.get(parameters: params)
        let response = try await client.apiClient.send(request)
        return response.value.data
    }

    func fetchProvisioningProfiles() async throws -> [Profile] {
        let params = Paths.Profiles.GetParameters(
            filterName: nil,
            filterProfileState: nil,
            filterProfileType: nil,
            filterID: nil,
            sort: nil,
            fieldsProfiles: nil,
            limit: nil,
            include: nil,
            fieldsCertificates: nil,
            fieldsDevices: nil,
            fieldsBundleIDs: nil,
            limitCertificates: nil,
            limitDevices: nil
        )

        let request = Paths.profiles.get(parameters: params)
        let response = try await client.apiClient.send(request)
        return response.value.data
    }

    func save(
        profile: Profile,
        toFile: URL
    ) async throws {
        guard
            let string = profile.attributes?.profileContent,
            let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters)
        else {
            throw SwiftlaneError.invalid("profile")
        }

        try data.write(to: toFile.ensuringExtension("mobileprovision"))
    }

    func save(
        certificate: Certificate,
        toFile: URL
    ) async throws {
        guard
            let string = certificate.attributes?.certificateContent,
            let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters)
        else {
            throw SwiftlaneError.invalid("certificate")
        }

        try data.write(to: toFile.ensuringExtension("cer"))
    }

    func install(
        profile: Profile
    ) async throws {
        guard
            let uuid = profile.attributes?.uuid
        else {
            throw SwiftlaneError.invalid("uuid")
        }

        try await save(
            profile: profile,
            toFile: Settings.fs.provisioningProfilesDirectory
                .appendingPathComponent(uuid)
                .appendingPathExtension("mobileprovision")
        )
    }

    func fetchPreReleaseVersions(
        filterPlatform: [Paths.PreReleaseVersions.GetParameters.FilterPlatform]? = nil,
        filterVersion: [String]? = nil,
        filterApp: [String]? = nil
    ) async throws -> [PrereleaseVersion] {
        let params = Paths.PreReleaseVersions.GetParameters(
            filterBuildsExpired: nil,
            filterBuildsProcessingState: nil,
            filterBuildsVersion: nil,
            filterPlatform: filterPlatform,
            filterVersion: filterVersion,
            filterApp: filterApp,
            filterBuilds: nil,
            sort: nil,
            fieldsPreReleaseVersions: nil,
            limit: nil,
            include: nil,
            fieldsApps: nil,
            fieldsBuilds: nil,
            limitBuilds: nil
        )

        let request = Paths.preReleaseVersions.get(parameters: params)
        let response = try await client.apiClient.send(request)
        return response.value.data
    }

    func fetchBuilds(
        preReleaseVersion: PrereleaseVersion
    ) async throws -> [AppStoreConnect.Build] {
        let request = Paths.preReleaseVersions
            .id(preReleaseVersion.id)
            .builds
            .get(
                fieldsBuilds: nil,
                limit: nil
            )
        let response = try await client.apiClient.send(request)
        return response.value.data
    }

    /// fetchLatestTestFlightBuildNumber
    /// - Parameters:
    ///   - filterVersion: version number. For example "1.0.0"
    ///   - filterApp: appId. For example 1503446681
    /// - Returns: build number
    func fetchLatestTestFlightBuildNumber(
        filterVersion: String,
        filterApp: String
    ) async throws -> String {
        let preReleaseVersions = try await fetchPreReleaseVersions(
            filterVersion: [filterVersion],
            filterApp: [filterApp]
        )

        guard let latestVersion = preReleaseVersions.first else {
            throw SwiftlaneError.invalid("latestVersion")
        }

        let builds = try await fetchBuilds(preReleaseVersion: latestVersion)

        guard let latestBuild = builds.first else {
            throw SwiftlaneError.invalid("latestBuild")
        }

        guard let buildNumber = latestBuild.attributes?.version else {
            throw SwiftlaneError.invalid("buildNumber")
        }

        return buildNumber
    }
}

