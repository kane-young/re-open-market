//
//  ItemListViewModelErrorTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

final class ItemListViewModelErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String
        
        expectedMessage = "UseCase Decoding Error"
        XCTAssertEqual(ItemListViewModelError.useCaseError(.decodingError).message, expectedMessage)
        
        expectedMessage = "UseCase Networking Error - dataTask작업 error 존재"
        XCTAssertEqual(ItemListViewModelError.useCaseError(.networkError(.connectionProblem)).message, expectedMessage)
        
        expectedMessage = "UseCase Reference Counting zero - 메모리 해제"
        XCTAssertEqual(ItemListViewModelError.useCaseError(.referenceCountingZero).message, expectedMessage)
    }
}
