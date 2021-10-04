//
//  MimeTypeTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

class MimeTypeTests: XCTestCase {
    func test_MimeTypeDescription() {
        var expectedDescription: String

        expectedDescription = "application/json"
        XCTAssertEqual(MimeType.applicationJson.description, expectedDescription)

        expectedDescription = "image/jpeg"
        XCTAssertEqual(MimeType.imageJpeg.description, expectedDescription)

        var expectedFileExtension: String

        expectedFileExtension = ".json"
        XCTAssertEqual(MimeType.applicationJson.fileExtension, expectedFileExtension)

        expectedFileExtension = ".jpeg"
        XCTAssertEqual(MimeType.imageJpeg.fileExtension, expectedFileExtension)
    }
}
