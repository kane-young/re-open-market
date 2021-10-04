//
//  StubItemListNetworkUseCase.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import Foundation
@testable import OpenMarket

final class StubSuccessItemListNetworkUseCase: ItemListNetworkUseCaseProtocol {
    func retrieveItems(completionHandler: @escaping (Result<[ItemList.Item], ItemListUseCaseError>) -> Void) {
        completionHandler(.success(Dummy.items))
    }
}

final class StubFailureItemListNetworkUseCase: ItemListNetworkUseCaseProtocol {
    func retrieveItems(completionHandler: @escaping (Result<[ItemList.Item], ItemListUseCaseError>) -> Void) {
        completionHandler(.failure(.decodingError))
    }
}
