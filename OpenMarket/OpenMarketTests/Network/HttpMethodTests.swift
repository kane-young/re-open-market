//
//  HttpMethodTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

class HttpMethodTests: XCTestCase {
    func test_HttpMethodDescription() {
        var expectedDescription: String

        expectedDescription = "GET"
        XCTAssertEqual(HttpMethod.get.description, expectedDescription)

        expectedDescription = "POST"
        XCTAssertEqual(HttpMethod.post.description, expectedDescription)

        expectedDescription = "PATCH"
        XCTAssertEqual(HttpMethod.patch.description, expectedDescription)

        expectedDescription = "DELETE"
        XCTAssertEqual(HttpMethod.delete.description, expectedDescription)
    }
}
