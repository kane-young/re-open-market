//
//  ItemDetailViewModelError.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/25.
//

import XCTest
@testable import OpenMarket

final class ItemDetailViewModelErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String
        
        expectedMessage = "UseCase Decoding Error"
        XCTAssertEqual(ItemDetailViewModelError.useCaseError(.decodingError).message, expectedMessage)
        
        expectedMessage = "UseCase Networking Error - dataTask작업 error 존재"
        XCTAssertEqual(ItemDetailViewModelError.useCaseError(.networkError(.connectionProblem)).message, expectedMessage)
    }
}
