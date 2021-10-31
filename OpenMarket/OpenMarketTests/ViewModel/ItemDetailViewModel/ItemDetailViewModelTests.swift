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

    func test_when_loadItem성공시_then_state_update로변경() {
        //given
        let dummyId = Dummy.id
        let stubSuccessItemNetworkUseCase = StubSuccessItemNetworkUseCase()
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: dummyId,
                                                      itemNetworkUseCase: stubSuccessItemNetworkUseCase,
                                                      imageNetworkUseCase: stubSuccessImageNetworkUseCase)
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .loading:
                break
            case .update(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemDetailViewModel.loadItem()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_loadItem실패시_then_state_error로변경() {
        //given
        let dummyId = Dummy.id
        let stubFailureItemNetworkUseCase = StubFailureItemNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: dummyId,
                                                      itemNetworkUseCase: stubFailureItemNetworkUseCase,
                                                      imageNetworkUseCase: dummyImageNetworkUseCase)
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .error(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemDetailViewModel.loadItem()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_imageLoad실패시_then_state_error로변경() {
        //given
        let dummyId = Dummy.id
        let stubSuccessItemNetworkUseCase = StubSuccessItemNetworkUseCase()
        let stubFailureImageNetworkUseCase = StubFailureImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: dummyId,
                                                      itemNetworkUseCase: stubSuccessItemNetworkUseCase,
                                                      imageNetworkUseCase: stubFailureImageNetworkUseCase)
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .error(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemDetailViewModel.loadItem()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_deleteItem성공시_then_state_delete로변경() {
        //given
        let dummyId = Dummy.id
        let dummyPassword = Dummy.password
        let stubSuccessItemNetworkUseCase = StubSuccessItemNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: dummyId,
                                                      itemNetworkUseCase: stubSuccessItemNetworkUseCase,
                                                      imageNetworkUseCase: dummyImageNetworkUseCase)
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .delete:
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemDetailViewModel.deleteItem(password: dummyPassword)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_deleteItem실패시_then_state_error로변경(){
        //given
        let dummyId = Dummy.id
        let dummyPassword = Dummy.password
        let stubFailureItemNetworkUseCase = StubFailureItemNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemDetailViewModel = ItemDetailViewModel(id: dummyId,
                                                      itemNetworkUseCase: stubFailureItemNetworkUseCase,
                                                      imageNetworkUseCase: dummyImageNetworkUseCase)
        itemDetailViewModel.bind { [weak self] state in
            switch state {
            case .error(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemDetailViewModel.deleteItem(password: dummyPassword)
        wait(for: [expectation], timeout: 2.0)
    }
}
