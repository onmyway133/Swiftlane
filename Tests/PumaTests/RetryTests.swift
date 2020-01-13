//
//  File.swift
//  
//
//  Created by skyylex on 13/01/2020.
//

import Foundation
import Spek
import XCTest
@testable import PumaCore

final class RetryTests: XCTestCase {
    func testSpec() {
        spec {
            Describe("Retry") {
                It("shouldn't retry with 0 attempts and task that fails") {
                    let retry = Retry(times: 0) { MockedTask(numberOfFailures: 1) }
                    let expectation = self.expectation(description: "Expect failure result in completion")
                    retry.run(workflow: Workflow()) { result in
                        switch (result) {
                        case .failure(_):
                            expectation.fulfill()
                        case .success(_):
                            XCTFail("Success result isn't expected")
                        }
                    }
                    
                    self.wait(for: [expectation], timeout: 0.1)
                }
                
                It("should complete successfully with 0 attempts and task that succeeds") {
                    let retry = Retry(times: 0) { MockedTask(numberOfFailures: 0) }
                    let expectation = self.expectation(description: "Expect success result in completion")
                    retry.run(workflow: Workflow()) { result in
                        switch (result) {
                        case .failure(_):
                            XCTFail("Failure result isn't expected")
                        case .success(_):
                            expectation.fulfill()
                        }
                    }
                    
                    self.wait(for: [expectation], timeout: 0.1)
                }
                
                It("should complete successfully with 3 attempts and task that fails 2 time") {
                    let retry = Retry(times: 3) { MockedTask(numberOfFailures: 2) }
                    let expectation = self.expectation(description: "Expect success result in completion")
                    retry.run(workflow: Workflow()) { result in
                        switch (result) {
                        case .failure(_):
                            XCTFail("Failure result isn't expected")
                        case .success(_):
                            expectation.fulfill()
                        }
                    }
                    
                    self.wait(for: [expectation], timeout: 0.1)
                }
                
                It("should complete with a failure with 2 attempts and task that fails 3 time") {
                    let retry = Retry(times: 2) { MockedTask(numberOfFailures: 3) }
                    let expectation = self.expectation(description: "Expect failure result in completion")
                    retry.run(workflow: Workflow()) { result in
                        switch (result) {
                        case .failure(_):
                            expectation.fulfill()
                        case .success(_):
                            XCTFail("Success result isn't expected")
                        }
                    }
                    
                    self.wait(for: [expectation], timeout: 0.1)
                }
            
            }
        }
    }
}

private extension RetryTests {
    class MockedTask: Task {
        var name: String = "A victim task of Retry"
        var isEnabled: Bool = true
        
        private var numberOfFailures = 0
        
        init(numberOfFailures: Int = 0) {
            self.numberOfFailures = numberOfFailures
        }
        
        func run(workflow: Workflow, completion: @escaping TaskCompletion) {
            guard numberOfFailures == 0 else {
                numberOfFailures -= 1;
                completion(.failure(ErrorType.retryError))
                return;
            }
            
            completion(Result.success(()))
        }
    }
    
    enum ErrorType: Error {
        case retryError
    }
}
