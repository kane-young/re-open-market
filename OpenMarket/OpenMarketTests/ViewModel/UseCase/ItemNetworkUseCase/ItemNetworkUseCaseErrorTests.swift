//
//  ItemNetworkUseCaseErrorTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/26.
//

import XCTest
@testable import OpenMarket

final class ItemNetworkUseCaseErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String
        
        expectedMessage = "Networking Error - dataTask작업 error 존재"
        XCTAssertEqual(ItemNetworkUseCaseError.networkError(.connectionProblem).message, expectedMessage)

        expectedMessage = "Decoding Error"
        XCTAssertEqual(ItemNetworkUseCaseError.decodingError.message, expectedMessage)
    }
}
