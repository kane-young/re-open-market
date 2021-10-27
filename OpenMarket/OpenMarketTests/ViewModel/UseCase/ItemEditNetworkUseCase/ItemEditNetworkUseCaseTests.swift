//
//  ItemEditNetworkUseCaseTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/26.
//

import XCTest
@testable import OpenMarket

final class ItemEditNetworkUseCaseTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_when_request_get성공시_then_success반환() {
        //given
        let stubSuccessItemNetworkManager = StubSuccessItemNetworkManager()
        let itemEditNetworkUseCase = ItemEditNetworkUseCase(networkManager: stubSuccessItemNetworkManager)
        //when
        itemEditNetworkUseCase.request(path: Dummy.urlString, with: nil, for: .get) { [weak self] result in
            switch result {
            case .success(_):
                //then
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_request_post실패시_then_failure반환() {
        //given
        let stubFailureNetworkManager = StubFailureNetworkManager()
        let itemEditNetworkUseCase = ItemEditNetworkUseCase(networkManager: stubFailureNetworkManager)
        //when
        itemEditNetworkUseCase.request(path: Dummy.urlString, with: Dummy.postItem, for: .post) { [weak self] result in
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

    func test_when_request_호출시_response로_decoding불가능한데이터가반환될경우_then_decodingError반환() {
        //given
        let stubSuccessItemListNetworkManager = StubSuccessItemListNetworkManager()
        let itemEditNetworkUseCase = ItemEditNetworkUseCase(networkManager: stubSuccessItemListNetworkManager)
        let expectedError = ItemEditNetworkUseCaseError.decodingError
        //when
        itemEditNetworkUseCase.request(path: Dummy.urlString, with: Dummy.patchItem, for: .patch) { [weak self] result in
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
}
