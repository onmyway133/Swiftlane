import Foundation
import XCTest
@testable import PumaCore

final class WaitTests: XCTestCase {
    private static let minTimeThreshold = 0.01
    
    func testZeroTimeout() {
        let wait = Wait()
        let workflow = Workflow()
        
        let expectation = self.expectation(description: "Expect zero timeout for completion call")
        wait.run(workflow: workflow) { (result) in
            guard result.isSuccessfull else {
                XCTFail("Only successfull completion is expected")
                return
            }
            
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: WaitTests.minTimeThreshold)
    }
    
    func testPositiveTimeout() {
        let positiveTimeout = 0.2
        
        let workflow = Workflow()
        let wait = Wait()
        wait.wait(for: positiveTimeout)
        
        let expectation = self.expectation(description: "Expect specified timeout for completion call")
        wait.run(workflow: workflow) { (result) in
            guard result.isSuccessfull else {
                XCTFail("Only successfull completion is expected")
                return
            }
            
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: positiveTimeout + WaitTests.minTimeThreshold)
    }
}

private extension Result where Success == Void {
    var isSuccessfull: Bool {
        return (try? get()) != nil
    }
}
