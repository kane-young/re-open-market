//
//  RequestMakerTest.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/09/26.
//

import XCTest
@testable import OpenMarket

class RequestMakerTest: XCTestCase {
    private var requestMaker: RequestMaker!
    private var dummyURL: URL!
    private enum Format {
        static let contentDisposition = "Content-Disposition: "
        static let contentType = "Content-Type"
        static let formData = "form-data"
        static let crlf = "\r\n"
        
        static func name(_ string: String) -> String {
            return "; name=\"\(string)\""
        }
        static func fileName(_ string: String) -> String {
            return "; fileName=\"\(string)\""
        }
        static func starting(_ boundary: String) -> String {
            return "--\(boundary)\(crlf)"
        }
        static func ending(_ boundary: String) -> String {
            return "--\(boundary)--\r\n"
        }
    }
    
    override func setUpWithError() throws {
        requestMaker = RequestMaker()
        dummyURL = URL(string: "www.kane.com")
    }
    
    override func tearDownWithError() throws {
        requestMaker = nil
        dummyURL = nil
    }
    
    func test_when_requestMaker로_DeleteItem에대한_request생성시_then_header_contentType확인() {
        //given
        let deleteItem = DeleteItem(password: "password")
        let expectedContentType = MimeType.applicationJson.description
        //when
        let request = requestMaker.request(url: dummyURL, httpMethod: .delete, with: deleteItem)
        let contentType = request?.value(forHTTPHeaderField: "Content-Type")
        //then
        XCTAssertEqual(contentType, expectedContentType)
    }
    
    func test_when_requestMaker로_PostItem에대한_request생성시_then_header_contentType확인() {
        //given
        let postItem = PostItem(title: "titel", descriptions: "description", price: 12, currency: "KRW", stock: 34, discountedPrice: 56, images: [Data()], password: "password")
        let expectedContentType = "multipart/form-data"
        //when
        let request = requestMaker.request(url: dummyURL, httpMethod: .post, with: postItem)
        guard let contentType = request?.value(forHTTPHeaderField: "Content-Type") else {
            XCTFail()
            return
        }
        //then
        XCTAssertTrue(contentType.contains(expectedContentType))
    }
}
