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

    func test_when_request_get성공시_result_success반환() {
        //given
        let stubSuccessItemDetailNetworkManager = StubSuccessItemDetailNetworkManager()
        let itemEditNetworkUseCase = ItemEditNetworkUseCase(networkManager: stubSuccessItemDetailNetworkManager)
        let dummyPath = "www.kane.com"
        //when
        itemEditNetworkUseCase.request(path: dummyPath, with: nil, for: .get) { [weak self] result in
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

    func test_when_request_post실패시_result_failure반환() {
        //given
        let stubFailureNetworkManager = StubFailureNetworkManager()
        let itemEditNetworkUseCase = ItemEditNetworkUseCase(networkManager: stubFailureNetworkManager)
        let dummyPath = "www.kane.com"
        //when
        itemEditNetworkUseCase.request(path: dummyPath, with: Dummy.postItem, for: .post) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_request_호출시_response로_decoding불가능한데이터가반환될경우_decodingError반환() {
        //given
        let stubSuccessItemListNetworkManager = StubSuccessItemListNetworkManager()
        let itemEditNetworkUseCase = ItemEditNetworkUseCase(networkManager: stubSuccessItemListNetworkManager)
        let dummyPath = "www.kane.com"
        //when
        itemEditNetworkUseCase.request(path: dummyPath, with: Dummy.patchItem, for: .patch) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
