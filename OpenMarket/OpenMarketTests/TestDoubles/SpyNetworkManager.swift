//
//  SpyNetworkManager.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/26.
//

import Foundation
@testable import OpenMarket

final class SpyNetworkManager: NetworkManagable {
    private(set) var requestCount: Int = 0
    func request(urlString: String, with item: Any?, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        requestCount += 1
        return nil
    }
}
