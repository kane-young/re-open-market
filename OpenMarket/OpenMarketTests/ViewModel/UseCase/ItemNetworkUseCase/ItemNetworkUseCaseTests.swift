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

    func test_when_retrieveItem호출성공시_then_success반환() {
        //given
        let dummyId = Dummy.id
        let stubSuccessItemNetworkManager = StubSuccessItemNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubSuccessItemNetworkManager)
        let expectedItem = Item(id: 1, title: "MacBook Pro", descriptions: "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다", price: 1690000, currency: "KRW", stock: 1000000000000, discountedPrice: nil, thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"], images: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"], registrationDate: 1611523563.719116)
        //when
        itemNetworkUseCase.retrieveItem(id: dummyId) { [weak self] result in
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

    func test_when_deleteItem호출성공시_then_success반환() {
        //given
        let dummyId = Dummy.id
        let dummyPassword = Dummy.password
        let stubSuccessItemNetworkManager = StubSuccessItemNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubSuccessItemNetworkManager)
        let expectedItem = Item(id: 1, title: "MacBook Pro", descriptions: "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다", price: 1690000, currency: "KRW", stock: 1000000000000, discountedPrice: nil, thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"], images: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"], registrationDate: 1611523563.719116)
        //when
        itemNetworkUseCase.deleteItem(id: dummyId, password: dummyPassword) { [weak self] result in
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

    func test_when_retrieveItem호출실패시_then_failure반환() {
        //given
        let dummyId = Dummy.id
        let stubFailureItemNetworkManager = StubFailureNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubFailureItemNetworkManager)
        //when
        itemNetworkUseCase.retrieveItem(id: dummyId) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                //then
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_deleteItem호출실패시_then_failure반환() {
        //given
        let dummyId = Dummy.id
        let dummyPassword = Dummy.password
        let stubFailureItemNetworkManager = StubFailureNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubFailureItemNetworkManager)
        //when
        itemNetworkUseCase.deleteItem(id: dummyId, password: dummyPassword) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                //then
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_retrieveItem호출성공후_Item으로Decoding되지않는_Data가response로왔을시_then_decodingError검출() {
        //given
        let dummyId = Dummy.id
        let stubSuccessItemListNetworkManager = StubSuccessItemListNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubSuccessItemListNetworkManager)
        //when
        itemNetworkUseCase.retrieveItem(id: dummyId) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                //then
                XCTAssertEqual(error, .decodingError)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_deleteItem호출후_Item으로Decoding되지않는_Data가response로왔을시_then_decodingError검출() {
        //given
        let dummyId = Dummy.id
        let dummyPassword = Dummy.password
        let stubSuccessItemListNetworkManager = StubSuccessItemListNetworkManager()
        let itemNetworkUseCase = ItemNetworkUseCase(networkManager: stubSuccessItemListNetworkManager)
        //when
        itemNetworkUseCase.deleteItem(id: dummyId, password: dummyPassword) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                //then
                XCTAssertEqual(error, .decodingError)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
        
    }
}
