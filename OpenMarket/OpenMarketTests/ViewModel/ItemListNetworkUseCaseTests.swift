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

    func test_useCase_retrieveItems성공() {
        //given
        let useCase: ItemListNetworkUseCase = .init(networkManager: StubSuccessItemListNetworkManager())
        let expectedItem = Item(id: 1, title: "MacBook Pro", descriptions: nil, price: 1690, currency: "USD", stock: 0, discountedPrice: nil, thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png", "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"], images: nil, registrationDate: 1611523563.7237701)
        //when
        useCase.retrieveItems { [weak self] result in
            switch result {
            case .success(let items):
                //then
                XCTAssertEqual(expectedItem.id, items.first!.id)
                XCTAssertEqual(expectedItem.title, items.first!.title)
                XCTAssertEqual(expectedItem.price, items.first!.price)
                XCTAssertEqual(expectedItem.currency, items.first!.currency)
                XCTAssertEqual(expectedItem.stock, items.first!.stock)
                XCTAssertEqual(expectedItem.discountedPrice, items.first!.discountedPrice)
                XCTAssertEqual(expectedItem.thumbnails, items.first!.thumbnails)
                XCTAssertEqual(expectedItem.registrationDate, items.first!.registrationDate)
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_useCase_retrieveItems실패() {
        //given
        let useCase: ItemListNetworkUseCase = .init(networkManager: StubFailureNetworkManager())
        let expectedError = ItemListUseCaseError.networkError(.connectionProblem)
        //when
        useCase.retrieveItems { [weak self] result in
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

    func test_useCase_retrieveItems_디코딩실패() {
        //given
        let useCase: ItemListNetworkUseCase = .init(networkManager: StubSuccessItemDetailNetworkManager())
        let expectedError = ItemListUseCaseError.decodingError
        //when
        useCase.retrieveItems { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                
                XCTAssertEqual(error, expectedError)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}

