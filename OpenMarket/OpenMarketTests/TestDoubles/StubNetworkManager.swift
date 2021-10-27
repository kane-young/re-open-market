//
//  StubNetworkManager.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import UIKit
@testable import OpenMarket

final class StubSuccessItemListNetworkManager: NetworkManagable {
    func request(urlString: String, with item: Any?, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let data = NSDataAsset(name: "MockItemList")?.data else {
            return nil
        }
        completion(.success(data))
        return nil
    }
}

final class StubFailureNetworkManager: NetworkManagable {
    func request(urlString: String, with item: Any?, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        completion(.failure(.connectionProblem))
        return nil
    }
}

final class StubSuccessItemNetworkManager: NetworkManagable {
    func request(urlString: String, with item: Any?, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let data = NSDataAsset(name: "MockItem")?.data else {
            return nil
        }
        completion(.success(data))
        return nil
    }
}

final class StubSuccessImageNetworkManager: NetworkManagable {
    func request(urlString: String, with item: Any?, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let data = UIImage(systemName: "pencil")?.pngData() else {
            completion(.failure(.invalidData))
            return nil
        }
        print(data)
        completion(.success(data))
        return nil
    }
}
