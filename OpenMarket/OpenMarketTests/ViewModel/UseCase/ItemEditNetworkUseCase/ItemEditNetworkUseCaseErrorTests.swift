//
//  ItemEditNetworkUseCaseErrorTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/26.
//

import XCTest
@testable import OpenMarket

final class ItemEditNetworkUseCaseErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String
        
        expectedMessage = "Networking Error - dataTask작업 error 존재"
        XCTAssertEqual(ItemEditNetworkUseCaseError.networkError(.connectionProblem).message, expectedMessage)

        expectedMessage = "Networking Error - 유효하지 않는 Request"
        XCTAssertEqual(ItemEditNetworkUseCaseError.networkError(.invalidRequest).message, expectedMessage)

        expectedMessage = "Decoding 에러 발생"
        XCTAssertEqual(ItemEditNetworkUseCaseError.decodingError.message, expectedMessage)
    }
}
