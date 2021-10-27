//
//  ItemListViewModelTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

final class ItemListViewModelTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_when_성공적loadItems시_then_state_initial로변경() {
        //given
        let stubSuccessItemListNetworkUseCase = StubSuccessItemListNetworkUseCase()
        let itemListViewModel = ItemListViewModel(useCase: stubSuccessItemListNetworkUseCase)
        itemListViewModel.bind { [weak self] state in
            switch state {
            case .initial:
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListViewModel.loadItems()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_loadItem실패시_then_state_error로변경() {
        //given
        let itemListViewModel = ItemListViewModel(useCase: StubFailureItemListNetworkUseCase())
        itemListViewModel.bind { [weak self] state in
            switch state {
            case .error(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListViewModel.loadItems()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_loadItems호출성공두번째_then_state_update로변경() {
        //given
        let itemListViewModel = ItemListViewModel(useCase: StubSuccessItemListNetworkUseCase())
        itemListViewModel.loadItems()
        itemListViewModel.bind { [weak self] state in
            switch state {
            case .update(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListViewModel.loadItems()
        wait(for: [expectation], timeout: 2.0)
    }
}
