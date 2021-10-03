//
//  NetworkingTest.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/09/26.
//

import XCTest
@testable import OpenMarket

final class NetworkManagerTest: XCTestCase {
    private var networkManager: NetworkManager!
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockURLSession = URLSession(configuration: configuration)
        networkManager = .init(urlSession: mockURLSession)
        expectation = .init()
    }

    override func tearDownWithError() throws {
        networkManager = nil
        expectation = nil
    }

    func test_when_아이템생성시_then_ErrorNotNil_connectionProblem에러발생() {
        //given
        let expectedError: NetworkError = .connectionProblem
        guard let path = OpenMarketAPI.postProduct.path else {
            XCTFail()
            return
        }
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: path, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, Data(), expectedError)
        }
        //when
        networkManager.request(urlString: OpenMarketAPI.postProduct.urlString,
                               with: Dummy.postItem, httpMethod: .post) { [weak self] result in
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

    func test_when_아이템수정시_then_statusCode가200번대가아닐경우_then_invalidResponse에러발생() {
        //given
        let expectedError: NetworkError = .invalidResponseStatuscode(404)
        guard let path = OpenMarketAPI.patchProduct(id: 10).path else {
            XCTFail()
            return
        }
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: path, statusCode: 404, httpVersion: nil, headerFields: nil)
            return (response, nil, nil)
        }
        //when
        networkManager.request(urlString: OpenMarketAPI.patchProduct(id: 10).urlString,
                               with: Dummy.patchItem, httpMethod: .patch) { [weak self] result in
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

    func test_when_encodable_multipartable하지않은item을request할경우_then_invalidRequest에러발생() {
        //given
        let expectedError: NetworkError = .invalidRequest
        //when
        networkManager.request(urlString: OpenMarketAPI.postProduct.urlString, with: Dummy.itemDetail,
                               httpMethod: .post) { [weak self] result in
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

    func test_when_아이템삭제요청시_then_data반환성공() {
        //given
        guard let dummyData: Data = try? JSONEncoder().encode(Dummy.deleteItem) else {
            XCTFail()
            return
        }
        guard let path = OpenMarketAPI.deleteProduct(id: 1).path else {
            XCTFail()
            return
        }
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: path, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, dummyData, nil)
        }
        //when
        networkManager.request(urlString: OpenMarketAPI.deleteProduct(id: 1).urlString, with: Dummy.deleteItem,
                               httpMethod: .delete) { [weak self] result in
            switch result {
            case .success(let data):
                //then
                XCTAssertNotNil(data)
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_itemList로드시_then_data반환성공() {
        //given
        guard let path = OpenMarketAPI.load(page: 1).path else {
            XCTFail()
            return
        }
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: path, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, Data(), nil)
        }
        //when
        networkManager.fetch(urlString: OpenMarketAPI.load(page: 1).urlString) { [weak self] result in
            switch result {
            case .success(let data):
                //then
                XCTAssertNotNil(data)
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
