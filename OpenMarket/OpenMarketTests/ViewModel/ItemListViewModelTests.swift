//
//  ItemListViewModelTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

final class ItemListViewModelTests: XCTestCase {
    private var itemListViewModel: ItemListViewModel!

    override func setUpWithError() throws {
        let stubItemListNetworkUseCase = StubItemListNetworkUseCase()
        itemListViewModel = ItemListViewModel(useCase: stubItemListNetworkUseCase)
    }

    override func tearDownWithError() throws {
        itemListViewModel = nil
    }

    func testBind() {
        let expectation = XCTestExpectation(description: "bindSuccess")
        itemListViewModel.bind { state in
            XCTAssertNotNil(state)
            expectation.fulfill()
        }
        itemListViewModel.loadItems()
        wait(for: [expectation], timeout: 2.0)
    }
}

final class StubItemListNetworkUseCase: ItemListNetworkUseCaseProtocol {
    func retrieveItems(completionHandler: @escaping (Result<[ItemList.Item], ItemListUseCaseError>) -> Void) {
        completionHandler(.success(Dummy.items))
    }
}
