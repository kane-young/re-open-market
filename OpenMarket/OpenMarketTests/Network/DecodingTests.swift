//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/09/23.
//

import XCTest
@testable import OpenMarket

final class DecodingTests: XCTestCase {
    var decoder: JSONDecoder!

    override func setUpWithError() throws {
        decoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        decoder = nil
    }

    func test_when_MockItem_decoding_then_decoding성공() {
        //given
        guard let asset = NSDataAsset(name: "MockItem") else {
            XCTFail()
            return
        }
        //when
        do {
            let item = try decoder.decode(Item.self, from: asset.data)
            //then
            XCTAssertEqual(item.title, "MacBook Pro")
        } catch {
            XCTFail()
        }
    }

    func test_when_MockItemList_decoding_then_decoding성공() {
        //given
        guard let asset = NSDataAsset(name: "MockItemList") else {
            XCTFail()
            return
        }
        //when
        do {
            let itemList = try decoder.decode(ItemList.self, from: asset.data)
            //then
            XCTAssertEqual(itemList.items.first?.title, "MacBook Pro")
        } catch {
            XCTFail()
        }
    }
}
