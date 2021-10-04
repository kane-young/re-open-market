//
//  ItemListCellViewModelErrorTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

class ItemListCellViewModelErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String
        
        expectedMessage = "URL 주소 존재하지 않음"
        XCTAssertEqual(ItemListCellViewModelError.emptyPath.message, expectedMessage)
        
        expectedMessage = "UseCase 에러 발생 Networking Error - dataTask작업 error 존재"
        XCTAssertEqual(ItemListCellViewModelError.useCaseError(.networkError(.connectionProblem)).message, expectedMessage)
    }
}
