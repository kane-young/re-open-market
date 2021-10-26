//
//  StubItemListNetworkUseCase.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import Foundation
@testable import OpenMarket

final class StubSuccessItemListNetworkUseCase: ItemListNetworkUseCaseProtocol {
    func retrieveItems(completionHandler: @escaping (Result<[Item], ItemListNetworkUseCaseError>) -> Void) {
        completionHandler(.success(Dummy.items))
    }

    func reset() {
        
    }
}

final class StubFailureItemListNetworkUseCase: ItemListNetworkUseCaseProtocol {
    func retrieveItems(completionHandler: @escaping (Result<[Item], ItemListNetworkUseCaseError>) -> Void) {
        completionHandler(.failure(.decodingError))
    }

    func reset() {
        
    }
}
