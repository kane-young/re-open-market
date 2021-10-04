//
//  NetworkErrorTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

class NetworkErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String

        expectedMessage = "dataTask작업 error 존재"
        XCTAssertEqual(NetworkError.connectionProblem.message, expectedMessage)

        expectedMessage = "유효하지 않는 URL"
        XCTAssertEqual(NetworkError.invalidURL.message, expectedMessage)

        expectedMessage = "dataTask작업 Data 미반환"
        XCTAssertEqual(NetworkError.invalidData.message, expectedMessage)

        expectedMessage = "유효하지 않는 Request"
        XCTAssertEqual(NetworkError.invalidRequest.message, expectedMessage)

        expectedMessage = "Response StatusCode 404"
        XCTAssertEqual(NetworkError.invalidResponseStatuscode(404).message, expectedMessage)
    }
}
