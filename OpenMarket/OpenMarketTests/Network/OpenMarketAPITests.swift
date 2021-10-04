//
//  OpenMarketAPITests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

class OpenMarketAPITests: XCTestCase {
    func test_OpenMarketAPI_urlString() {
        var expectedUrlString: String

        expectedUrlString = "https://camp-open-market-2.herokuapp.com/items/1"
        XCTAssertEqual(OpenMarketAPI.load(page: 1).urlString, expectedUrlString)

        expectedUrlString = "https://camp-open-market-2.herokuapp.com/item/1"
        XCTAssertEqual(OpenMarketAPI.loadProduct(id: 1).urlString, expectedUrlString)

        expectedUrlString = "https://camp-open-market-2.herokuapp.com/item/1"
        XCTAssertEqual(OpenMarketAPI.patchProduct(id: 1).urlString, expectedUrlString)

        expectedUrlString = "https://camp-open-market-2.herokuapp.com/item/"
        XCTAssertEqual(OpenMarketAPI.postProduct.urlString, expectedUrlString)

        expectedUrlString = "https://camp-open-market-2.herokuapp.com/item/1"
        XCTAssertEqual(OpenMarketAPI.deleteProduct(id: 1).urlString, expectedUrlString)
    }

    func test_OpenMarketAPI_path() {
        var expectedUrl: URL?

        expectedUrl = URL(string: "https://camp-open-market-2.herokuapp.com/items/1")
        XCTAssertEqual(OpenMarketAPI.load(page: 1).path, expectedUrl)

        expectedUrl = URL(string: "https://camp-open-market-2.herokuapp.com/item/1")
        XCTAssertEqual(OpenMarketAPI.loadProduct(id: 1).path, expectedUrl)

        expectedUrl = URL(string: "https://camp-open-market-2.herokuapp.com/item/1")
        XCTAssertEqual(OpenMarketAPI.patchProduct(id: 1).path, expectedUrl)

        expectedUrl = URL(string: "https://camp-open-market-2.herokuapp.com/item/")
        XCTAssertEqual(OpenMarketAPI.postProduct.path, expectedUrl)

        expectedUrl = URL(string: "https://camp-open-market-2.herokuapp.com/item/1")
        XCTAssertEqual(OpenMarketAPI.deleteProduct(id: 1).path, expectedUrl)
    }
}
