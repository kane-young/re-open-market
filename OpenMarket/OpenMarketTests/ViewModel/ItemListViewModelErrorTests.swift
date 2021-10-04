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
        
        expectedMessage = "ViewModel UseCase Decoding Error 발생"
        XCTAssertEqual(ItemListViewModelError.useCaseError(.decodingError).message, expectedMessage)
        
        expectedMessage = "ViewModel UseCase Networking Error - connectionProblem 발생"
        XCTAssertEqual(ItemListViewModelError.useCaseError(.networkError(.connectionProblem)).message, expectedMessage)
        
        expectedMessage = "ViewModel UseCase Reference Counting zero - 메모리 해제 발생"
        XCTAssertEqual(ItemListViewModelError.useCaseError(.referenceCountingZero).message, expectedMessage)
    }
}
