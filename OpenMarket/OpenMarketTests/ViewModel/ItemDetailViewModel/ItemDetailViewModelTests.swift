//
//  ItemDetailViewModelTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/25.
//

import XCTest
@testable import OpenMarket

final class ItemDetailViewModelTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_itemDetailViewModel_loadItem성공시_state_update로변경() {
        //given
        let stubSuccessItemNetworkUseCase = StubSuccessItemNetworkUseCase()
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: Dummy.id,
                                                      itemNetworkUseCase: stubSuccessItemNetworkUseCase,
                                                      imageNetworkUseCase: stubSuccessImageNetworkUseCase)
        //when
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .update(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemDetailViewModel.loadItem()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemDetailViewModel_loadItem실패시_state_error로변경() {
        //given
        let stubFailureItemNetworkUseCase = StubFailureItemNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: Dummy.id,
                                                      itemNetworkUseCase: stubFailureItemNetworkUseCase,
                                                      imageNetworkUseCase: dummyImageNetworkUseCase)
        //when
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .error(let error):
                //then
                self?.expectation.fulfill()
                XCTAssertEqual(error, .useCaseError(.networkError(.connectionProblem)))
            default:
                XCTFail()
            }
        }
        itemDetailViewModel.loadItem()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemDetailViewModel_imageLoad실패시_state_error로변경() {
        //given
        let stubSuccessItemNetworkUseCase = StubSuccessItemNetworkUseCase()
        let stubFailureImageNetworkUseCase = StubFailureImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: Dummy.id,
                                                      itemNetworkUseCase: stubSuccessItemNetworkUseCase,
                                                      imageNetworkUseCase: stubFailureImageNetworkUseCase)
        //when
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .error(let error):
                //then
                self?.expectation.fulfill()
                XCTAssertEqual(error, .imageUseCaseError(.networkError(.invalidRequest)))
            default:
                XCTFail()
            }
        }
        itemDetailViewModel.loadItem()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemDetailViewModel_deleteItem성공시_state_delete로변경() {
        //given
        let stubSuccessItemNetworkUseCase = StubSuccessItemNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: Dummy.id,
                                                      itemNetworkUseCase: stubSuccessItemNetworkUseCase,
                                                      imageNetworkUseCase: dummyImageNetworkUseCase)
        //when
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .delete:
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemDetailViewModel.deleteItem(password: Dummy.password)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemDetailViewModel_deleteItem실패시_state_delete로변경(){
        //given
        let stubFailureItemNetworkUseCase = StubFailureItemNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: Dummy.id,
                                                      itemNetworkUseCase: stubFailureItemNetworkUseCase,
                                                      imageNetworkUseCase: dummyImageNetworkUseCase)
        //when
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .error(let error):
                //then
                self?.expectation.fulfill()
                XCTAssertEqual(error, .useCaseError(.networkError(.connectionProblem)))
            default:
                XCTFail()
            }
        }
        itemDetailViewModel.deleteItem(password: Dummy.password)
        wait(for: [expectation], timeout: 2.0)
    }
}
