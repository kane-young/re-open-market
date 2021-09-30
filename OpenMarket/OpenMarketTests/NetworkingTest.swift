//
//  NetworkingTest.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/09/26.
//

import XCTest
@testable import OpenMarket

class NetworkingTest: XCTestCase {
    private var networkManager: NetworkManager!
    private var dummyUrlString: String!
    private var dummyUrl: URL!
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLSession.self]
        let mockURLSession = URLSession(configuration: configuration)
        networkManager = NetworkManager(urlSession: mockURLSession)
        dummyUrlString = "www.kane.com"
        dummyUrl = URL(string: dummyUrlString)
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        networkManager = nil
        expectation = nil
    }
    
    func test_when_아이템생성시_then_error_notNil_connectionProblem에러발생() {
        //given
        MockURLSession.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.dummyUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, Data(), NetworkError.connectionProblem)
        }
        let dummyItem = PostItem(title: "dummy", descriptions: "item", price: 123, currency: "KRW", stock: 11, discountedPrice: 33, images: [Data()], password: "password")
        //when
        networkManager.request(urlString: dummyUrlString, with: dummyItem, httpMethod: .post) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                //then
                XCTAssertEqual(error.message, NetworkError.connectionProblem.message)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_when_아이템수정시_then_statusCode가200번대가아닐경우_then_invalidResponse에러발생() {
        //given
        MockURLSession.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.dummyUrl, statusCode: 404, httpVersion: nil, headerFields: nil)
            return (response, nil, nil)
        }
        let dummyItem = PatchItem(title: "dummy", descriptions: "item", price: 123, currency: "KRW", stock: 11, discountedPrice: 33, images: [Data()], password: "password")
        //when
        networkManager.request(urlString: dummyUrlString, with: dummyItem, httpMethod: .patch) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                //then
                XCTAssertEqual(error.message, NetworkError.invalidResponseStatuscode(404).message)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_when_encodable_multipartable하지않은item을request할경우_then_invalidRequest에러발생() {
        //given
        let mockItem = Item(id: 1, title: "title", descriptions: "description", price: 123, currency: "KRw", stock: 33, discountedPrice: nil, thumbnails: ["www.kane.com"], images: ["www.kane.com"], registrationDate: 3.0)
        //when
        networkManager.request(urlString: dummyUrlString, with: mockItem, httpMethod: .post) { [weak self] result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.message, NetworkError.invalidRequest.message)
                self?.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_when_아이템삭제요청시_then_data반환성공() {
        //given
        let dummyItem = DeleteItem(password: "password")
        guard let dummyData: Data = try? JSONEncoder().encode(dummyItem) else {
            XCTFail()
            return
        }
        MockURLSession.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.dummyUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, dummyData, nil)
        }
        //when
        networkManager.request(urlString: dummyUrlString, with: dummyItem, httpMethod: .delete) { [weak self] result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_when_fetch시_error_nil_response_200_올바른data_then_data반환성공() {
        //given
        MockURLSession.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.dummyUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, Data(), nil)
        }
        //when
        networkManager.fetch(urlString: dummyUrlString) { [weak self] result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
