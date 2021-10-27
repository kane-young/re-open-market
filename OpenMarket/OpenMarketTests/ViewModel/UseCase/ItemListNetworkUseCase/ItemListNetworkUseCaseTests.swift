//
//  ItemListNetworkUseCaseTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

final class ItemListNetworkUseCaseTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_when_retrieveItems_networking성공시_then_items반환() {
        //given
        let stubSuccessItemListNetworkManager = StubSuccessItemListNetworkManager()
        let itemListNetworkUseCase = ItemListNetworkUseCase(networkManager: stubSuccessItemListNetworkManager)
        let expectedItem = Item(id: 1, title: "MacBook Pro", descriptions: nil, price: 1690,
                                currency: "USD", stock: 0, discountedPrice: nil,
                                thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                             "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"],
                                images: nil, registrationDate: 1611523563.7237701)
        //when
        itemListNetworkUseCase.retrieveItems { [weak self] result in
            switch result {
            case .success(let items):
                guard let firstItem = items.first else { return }
                //then
                XCTAssertEqual(expectedItem.id, firstItem.id)
                XCTAssertEqual(expectedItem.title, firstItem.title)
                XCTAssertEqual(expectedItem.price, firstItem.price)
                XCTAssertEqual(expectedItem.currency, firstItem.currency)
                XCTAssertEqual(expectedItem.stock, firstItem.stock)
                XCTAssertEqual(expectedItem.discountedPrice, firstItem.discountedPrice)
                XCTAssertEqual(expectedItem.thumbnails, firstItem.thumbnails)
                XCTAssertEqual(expectedItem.registrationDate, firstItem.registrationDate)
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_retrieveItems_networking실패시_then_networkingError반환() {
        //given
        let stubFailureNetworkManager = StubFailureNetworkManager()
        let itemListNetworkUseCase = ItemListNetworkUseCase(networkManager: stubFailureNetworkManager)
        let expectedError = ItemListNetworkUseCaseError.networkError(.connectionProblem)
        //when
        itemListNetworkUseCase.retrieveItems { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                //then
                XCTAssertEqual(error, expectedError)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_retrieveItems호출시_디코딩실패할경우_then_decodingError반환() {
        //given
        let stubSuccessItemNetworkManager = StubSuccessItemNetworkManager()
        let itemListNetworkUseCase = ItemListNetworkUseCase(networkManager: stubSuccessItemNetworkManager)
        let expectedError = ItemListNetworkUseCaseError.decodingError
        //when
        itemListNetworkUseCase.retrieveItems { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                //then
                XCTAssertEqual(error, expectedError)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_loading중일때retrieveItems호출시_then한번만수행() {
        //given
        let spyNetworkManager = SpyNetworkManager()
        let itemListNetworkUseCase = ItemListNetworkUseCase(networkManager: spyNetworkManager)
        let expectedRequestCount = 1
        //when
        itemListNetworkUseCase.retrieveItems { _ in }
        itemListNetworkUseCase.retrieveItems { _ in }
        //then
        XCTAssertEqual(spyNetworkManager.requestCount, expectedRequestCount)
    }
}

