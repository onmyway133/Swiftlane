//
//  ShowUsers.swift
//  Basic
//
//  Created by Besar Ismaili on 22/02/2020.
//

import Foundation
import PumaCore


public class ShowUsers {
    public var name: String = "Download and show the list of the users on your team."
    public var isEnabled = true
    
    var configuration: APIConfiguration?
    
    public init(_ closure: (ShowUsers) -> Void = { _ in }) {
        closure(self)
    }
}

extension ShowUsers: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            let group = DispatchGroup()
            let provider = APIProvider(configuration: configuration!)
            let endpoint = APIEndpoint.users()
            group.enter()
            provider.request(endpoint) { (result) in
                switch result {
                case .success(let userResponse):
                    self.show(userResponse, logger: workflow.logger)
                case .failure(let error):
                    workflow.logger.log("Something went wrong while fetching the users: \(error)")
                }
                group.leave()
            }
            group.wait()
        }
    }
    
    private func show(_ userResponse: UsersResponse, logger: Logger) {
        for user in userResponse.data {
            if let attributes = user.attributes {
                let firstName = attributes.firstName
                let lastName = attributes.lastName
                let roles = prepareRoles(from: user.attributes?.roles)
                let userInfo = "\(firstName ?? "") \(lastName ?? "") - \(roles)"
                logger.log(userInfo)
            }
        }
    }
    
    private func prepareRoles(from userRoles: [UserRole]?) -> String {
        var roles = ""
        for role in userRoles ?? [] {
            roles += role.rawValue + ","
        }
        //this removes the last comma
        if !roles.isEmpty {
            roles.removeLast()
        }
        return roles
    }
}

public extension ShowUsers {
    func authenticate(issuerID: String, privateKeyID: String, privateKey: String) {
        self.configuration = APIConfiguration(
            issuerID: issuerID,
            privateKeyID: privateKeyID,
            privateKey: privateKey
        )
    }
}

