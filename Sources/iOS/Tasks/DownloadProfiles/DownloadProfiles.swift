//
//  DownloadProfiles.swift
//  Basic
//
//  Created by Besar Ismaili on 20/02/2020.
//


import Foundation
import PumaCore


public class DownloadProfiles {
    public var name: String = "Find and list provisioning profiles and download their data."
    public var isEnabled = true
    
    var configuration: APIConfiguration?
    
    var saveDirectory: String?
    
    public init(_ closure: (DownloadProfiles) -> Void = { _ in }) {
        closure(self)
    }
}

extension DownloadProfiles: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            guard let saveDirectory = saveDirectory else {
                throw PumaError.invalid
            }

            let endpoint = APIEndpoint.listProfiles()
            
            let group = DispatchGroup()
            group.enter()
            
            let provider: APIProvider = APIProvider(configuration: configuration!)
            
            workflow.logger.log(configuration.debugDescription)
                provider.request(endpoint) { (result) in
                    switch result {
                    case .success(let appsResponse):
                        workflow.logger.log("did fetch profiles")
                        group.leave()
                    case .failure(let error):
                        workflow.logger.log("Something went wrong fetching the profiles")
                        group.leave()
                    }
            }
            group.wait()
        }
    }
}

public extension DownloadProfiles {
    func authenticate(issuerID: String, privateKeyID: String, privateKey: String) {
        self.configuration = APIConfiguration(
            issuerID: issuerID,
            privateKeyID: privateKeyID,
            privateKey: privateKey
        )
    }
    
    // Download app metadata
    func download(saveDirectory: String) {
        self.saveDirectory = saveDirectory
    }
}

