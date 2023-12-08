import XCTest
@testable import OneTwoIdProvider

final class OneTwoIdProviderTests: XCTestCase {
     func testExample() {
        let expectation = XCTestExpectation(description: "Network request")

        MyNetworkPod.makeGetRequest { result in
            switch result {
            case .success(let response):
                print("Response: \(response)")
                XCTAssertNotNil(response)
            case .failure(let error):
                print("Error: \(error)")
                XCTAssertNil(error)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
