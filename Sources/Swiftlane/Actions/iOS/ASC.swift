//
//  AppStoreConnect.swift
//  Swiftlane
//
//  Created by khoa on 12/02/2022.
//

import AppStoreConnect

public struct ASC {
    public let client: AppStoreConnect.Client

    public init(credential: AppStoreConnect.Credential) throws {
        self.client = try AppStoreConnect.Client(credential: credential)
    }
}

public extension ASC {
    func fetchCertificates() async throws -> CertificatesResponse {
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
        return response.value
    }

    func fetchProvisioningProfiles() async throws -> ProfilesResponse {
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
        return response.value
    }
}
