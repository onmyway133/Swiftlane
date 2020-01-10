import XCTest
import Foundation
@testable import PumaCore

private final class MockedTask: Task {
    typealias ResultType = Result<Void, Error>
    
    var name = ""
    var result: ResultType
    var isEnabled = true
    
    // Test execution results
    var isCompleted = false
    var usedWorkflow: Workflow?
    
    static func successfulTask() -> MockedTask {
        return MockedTask(result: .success(()))
    }
    
    static func failedTask() -> MockedTask {
        return MockedTask(result: .failure(ErrorType.sampleError))
    }
    
    init(result: Result<(), Error>) {
        self.result = result
    }
    
    func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        isCompleted = true
        usedWorkflow = workflow
        
        completion(result)
    }
    
    
    enum ErrorType: Error {
        case sampleError
    }
}

final class WorkflowTests: XCTestCase {
    func testRunSeveralSuccessfullTasks() {
        let tasks = [MockedTask.successfulTask(), MockedTask.successfulTask()]
        let workflow = Workflow(tasks: tasks)
        
        let expectation = self.expectation(description: "Expect to receive .success result in completion of run()")
        workflow.run { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Failure result isn't expected")
            }
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertTrue(tasks.allSatisfy { $0.isCompleted && $0.usedWorkflow === workflow })
    }
    
    func testRunSeveralTasksWithOneFailed() {
        let tasks = [MockedTask.failedTask(), MockedTask.failedTask()]
        let workflow = Workflow(tasks: tasks)
        
        let expectation = self.expectation(description: "Expect to receive .failure result in completion of run()")
        workflow.run { result in
            switch result {
            case .success(_):
                XCTFail("Success result isn't expected")
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertEqual(tasks.filter { $0.isCompleted && $0.usedWorkflow === workflow }.count, 1)
    }
    
    func testRunSeveralTasksWithFirstFailed() {
       let tasks = [MockedTask.failedTask(), MockedTask.successfulTask()]
       let workflow = Workflow(tasks: tasks)
       
       let expectation = self.expectation(description: "Expect to receive .failure result in completion of run()")
       workflow.run { result in
           switch result {
           case .success(_):
               XCTFail("Success result isn't expected")
           case .failure(_):
               expectation.fulfill()
           }
       }
       
       wait(for: [expectation], timeout: 0.1)
       
       XCTAssertEqual(tasks.filter { $0.isCompleted && $0.usedWorkflow === workflow }.count, 1)
   }
}
