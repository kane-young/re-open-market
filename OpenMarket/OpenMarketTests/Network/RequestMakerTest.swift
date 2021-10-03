//
//  RequestMakerTest.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/09/26.
//

import XCTest
@testable import OpenMarket

final class RequestMakerTest: XCTestCase {
    private var requestMaker: RequestMaker!

    override func setUpWithError() throws {
        requestMaker = RequestMaker()
    }

    override func tearDownWithError() throws {
        requestMaker = nil
    }

    func test_when_requestMaker로_DeleteItem에대한_request생성시_then_header_contentType확인() {
        //given
        guard let path = OpenMarketAPI.deleteProduct(id: 1).path else {
            XCTFail()
            return
        }
        let expectedContentType = MimeType.applicationJson.description
        //when
        let request = requestMaker.request(url: path, httpMethod: .delete, with: Dummy.deleteItem)
        //then
        let contentType = request?.value(forHTTPHeaderField: "Content-Type")
        XCTAssertEqual(contentType, expectedContentType)
    }
    
    func test_when_requestMaker로_PostItem에대한_request생성시_then_header_contentType확인() {
        //given
        guard let path = OpenMarketAPI.postProduct.path else {
            XCTFail()
            return
        }
        let expectedContentType = "multipart/form-data"
        //when
        let request = requestMaker.request(url: path, httpMethod: .post, with: Dummy.postItem)
        //then
        guard let contentType = request?.value(forHTTPHeaderField: "Content-Type") else {
            XCTFail()
            return
        }
        XCTAssertTrue(contentType.contains(expectedContentType))
    }
}
