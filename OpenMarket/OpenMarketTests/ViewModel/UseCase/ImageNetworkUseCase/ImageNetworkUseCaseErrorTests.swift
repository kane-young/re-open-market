//
//  ImageNetworkUseCaseErrorTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/26.
//

import XCTest
@testable import OpenMarket

final class ImageNetworkUseCaseErrorTests: XCTestCase {
    func testErrorMessage() {
        var expectedMessage: String
        
        expectedMessage = "Networking Error - dataTask작업 error 존재"
        XCTAssertEqual(ImageNetworkUseCaseError.networkError(.connectionProblem).message, expectedMessage)

        expectedMessage = "Invalid URL 주소"
        XCTAssertEqual(ImageNetworkUseCaseError.invalidURL.message, expectedMessage)

        expectedMessage = "Can't convert Data to Image error"
        XCTAssertEqual(ImageNetworkUseCaseError.convertDataToImageError.message, expectedMessage)
    }
}
