//
//  ItemListNetworkUseCaseErrorTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/26.
//

import XCTest
@testable import OpenMarket

final class ItemListNetworkUseCaseErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String
        
        expectedMessage = "Networking Error - dataTask작업 error 존재"
        XCTAssertEqual(ItemListNetworkUseCaseError.networkError(.connectionProblem).message, expectedMessage)

        expectedMessage = "Decoding Error"
        XCTAssertEqual(ItemListNetworkUseCaseError.decodingError.message, expectedMessage)

        expectedMessage = "Reference Counting zero - 메모리 해제"
        XCTAssertEqual(ItemListNetworkUseCaseError.referenceCountingZero.message, expectedMessage)
    }
}
