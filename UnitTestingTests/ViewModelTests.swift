//
//  ViewModelTests.swift
//  UnitTestingTests
//
//  Created by Maksim Vialykh on 7/17/21.
//

import XCTest
@testable
import UnitTesting

class MockNetworkClient: NetworkClient {
    var mockedResult: Result<Data, Error> = .failure(NetworkError.noData)
    func send(request: URLRequest, result: @escaping (Result<Data, Error>) -> Void) {
        result(mockedResult)
    }
}

class MockRouter: Router {
    var openMainViewExpectation = XCTestExpectation(description: "openMainView expectation")
    func openMainView() {
        openMainViewExpectation.fulfill()
    }
}

class ViewModelTests: XCTestCase {
    
    let viewModelOnErrorExpectation = XCTestExpectation(description: "viewModel expectation")
    let timeout = 0.5
    var viewModel: DefaultViewModel!
    var client: MockNetworkClient!
    var router: MockRouter!

    override func setUpWithError() throws {
        client = MockNetworkClient()
        router = MockRouter()
        viewModel = DefaultViewModel(
            client: client,
            router: router
        )
    }

    override func tearDownWithError() throws {
        client = nil
        router = nil
        viewModel = nil
    }

    func testEmptyUsernameFail() throws {
        // Configure
        viewModel.onError = { [weak self] error in
            // Check
            XCTAssertEqual(error as? SignupError, SignupError.emptyUsername)
            self?.viewModelOnErrorExpectation.fulfill()
        }
        // Act
        viewModel.signup(username: nil, password: nil)
        // Wait
        wait(for: [viewModelOnErrorExpectation], timeout: timeout)
    }
    
    func testEmptyPasswordFail() throws {
        // Configure
        viewModel.onError = { [weak self] error in
            // Check
            XCTAssertEqual(error as? SignupError, SignupError.emptyPassword)
            self?.viewModelOnErrorExpectation.fulfill()
        }
        // Act
        viewModel.signup(username: "testUsername", password: nil)
        // Wait
        wait(for: [viewModelOnErrorExpectation], timeout: timeout)
    }
    
    func testNetworkFail() throws {
        // Configure
        let expectedError = NetworkError.noData
        client.mockedResult = .failure(expectedError)
        viewModel.onError = { [weak self] error in
            // Check
            XCTAssertEqual(error as? NetworkError, expectedError)
            self?.viewModelOnErrorExpectation.fulfill()
        }
        // Act
        viewModel.signup(username: "testUsername", password: "testPassword")
        // Wait
        wait(for: [viewModelOnErrorExpectation], timeout: timeout)
    }
    
    func testSignupSuccess() throws {
        // Configure
        client.mockedResult = .success(Data())
        router.openMainViewExpectation.expectedFulfillmentCount = 1
        // Act
        viewModel.signup(username: "testUsername", password: "testPassword")
        // Wait
        wait(for: [router.openMainViewExpectation], timeout: timeout)
    }

}
