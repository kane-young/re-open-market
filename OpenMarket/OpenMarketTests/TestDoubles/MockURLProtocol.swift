//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/09/26.
//

import Foundation
import XCTest

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError()
        }
        
        let (response, data, error) = handler(request)
        
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        if let response = response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
