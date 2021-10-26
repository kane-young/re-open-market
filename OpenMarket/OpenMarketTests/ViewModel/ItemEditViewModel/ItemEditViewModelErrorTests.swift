//
//  ItemEditViewModelErrorTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/26.
//

import XCTest
@testable import OpenMarket

final class ItemEditViewModelErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String
        
        expectedMessage = "Item Edit UseCase Decoding 에러 발생"
        XCTAssertEqual(ItemEditViewModelError.editUseCaseError(.decodingError).message, expectedMessage)

        expectedMessage = "Item Edit UseCase Networking Error - dataTask작업 Data 미반환"
        XCTAssertEqual(ItemEditViewModelError.editUseCaseError(.networkError(.invalidData)).message, expectedMessage)

        expectedMessage = "Image Load UseCase Can't convert Data to Image error"
        XCTAssertEqual(ItemEditViewModelError.imageUseCaseError(.convertDataToImageError).message, expectedMessage)

        expectedMessage = "Image Load UseCase Networking Error - dataTask작업 error 존재"
        XCTAssertEqual(ItemEditViewModelError.imageUseCaseError(.networkError(.connectionProblem)).message, expectedMessage)
    }
}
