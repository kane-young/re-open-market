//
//  ItemNetworkUseCaseTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/25.
//

import XCTest
@testable import OpenMarket

final class ItemNetworkUseCaseTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_itemNetworkUseCase_retrieveItem호출시_networkingAndDecoding성공() {
        //given
        let stubSuccessItemDetailNetworkManager = StubSuccessItemDetailNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubSuccessItemDetailNetworkManager)
        let expectedItem = Item(id: 1, title: "MacBook Pro", descriptions: "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다", price: 1690000, currency: "KRW", stock: 1000000000000, discountedPrice: nil, thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"], images: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"], registrationDate: 1611523563.719116)
        //when
        itemNetworkUseCase.retrieveItem(id: Dummy.id) { [weak self] result in
            switch result {
            case .success(let item):
                //then
                XCTAssertEqual(item.id, expectedItem.id)
                XCTAssertEqual(item.title, expectedItem.title)
                XCTAssertEqual(item.descriptions, expectedItem.descriptions)
                XCTAssertEqual(item.price, expectedItem.price)
                XCTAssertEqual(item.currency, expectedItem.currency)
                XCTAssertEqual(item.stock, expectedItem.stock)
                XCTAssertEqual(item.discountedPrice, expectedItem.discountedPrice)
                XCTAssertEqual(item.thumbnails, expectedItem.thumbnails)
                XCTAssertEqual(item.images, expectedItem.images)
                XCTAssertEqual(item.registrationDate, expectedItem.registrationDate)
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemNetworkUseCase_deleteItem호출시_networkingAndDecoding성공() {
        //given
        let stubSuccessItemDetailNetworkManager = StubSuccessItemDetailNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubSuccessItemDetailNetworkManager)
        let expectedItem = Item(id: 1, title: "MacBook Pro", descriptions: "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다", price: 1690000, currency: "KRW", stock: 1000000000000, discountedPrice: nil, thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"], images: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"], registrationDate: 1611523563.719116)
        //when
        itemNetworkUseCase.deleteItem(id: Dummy.id, password: Dummy.password) { [weak self] result in
            switch result {
            case .success(let item):
                //then
                XCTAssertEqual(item.id, expectedItem.id)
                XCTAssertEqual(item.title, expectedItem.title)
                XCTAssertEqual(item.descriptions, expectedItem.descriptions)
                XCTAssertEqual(item.price, expectedItem.price)
                XCTAssertEqual(item.currency, expectedItem.currency)
                XCTAssertEqual(item.stock, expectedItem.stock)
                XCTAssertEqual(item.discountedPrice, expectedItem.discountedPrice)
                XCTAssertEqual(item.thumbnails, expectedItem.thumbnails)
                XCTAssertEqual(item.images, expectedItem.images)
                XCTAssertEqual(item.registrationDate, expectedItem.registrationDate)
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemNetworkUseCase_retrieveItem호출시_특정error검출() {
        //given
        let stubFailureItemNetworkManager = StubFailureNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubFailureItemNetworkManager)
        //when
        itemNetworkUseCase.retrieveItem(id: Dummy.id) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                //then
                XCTAssertEqual(error, .networkError(.connectionProblem))
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemNetworkUseCase_deleteItem호출시_특정error검출() {
        //given
        let stubFailureItemNetworkManager = StubFailureNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubFailureItemNetworkManager)
        //when
        itemNetworkUseCase.deleteItem(id: Dummy.id, password: Dummy.password) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                //then
                XCTAssertEqual(error, .networkError(.connectionProblem))
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
