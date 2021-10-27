//
//  StubItemNetworkUseCase.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/25.
//

import Foundation
@testable import OpenMarket

final class StubSuccessItemNetworkUseCase: ItemNetworkUseCaseProtocol {
    func retrieveItem(id: Int, completionHandler: @escaping (Result<Item, ItemNetworkUseCaseError>) -> Void) {
        let item = Item(id: id, title: "itemTitle", descriptions: "Descriptions", price: 10,
                        currency: "KRW", stock: 11, discountedPrice: 12, thumbnails: ["https://www.kane.com"],
                        images: ["https://www.kane.com"], registrationDate: 123455)
        completionHandler(.success(item))
    }
    
    func deleteItem(id: Int, password: String, completionHandler: @escaping (Result<Item, ItemNetworkUseCaseError>) -> Void) {
        let item = Item(id: id, title: "itemTitle", descriptions: "Descriptions", price: 10,
                        currency: "KRW", stock: 11, discountedPrice: 12, thumbnails: ["https://www.kane.com"],
                        images: ["https://www.kane.com"], registrationDate: 123455)
        completionHandler(.success(item))
    }
}

final class StubFailureItemNetworkUseCase: ItemNetworkUseCaseProtocol {
    func retrieveItem(id: Int, completionHandler: @escaping (Result<Item, ItemNetworkUseCaseError>) -> Void) {
        completionHandler(.failure(.networkError(.connectionProblem)))
    }

    func deleteItem(id: Int, password: String, completionHandler: @escaping (Result<Item, ItemNetworkUseCaseError>) -> Void) {
        completionHandler(.failure(.networkError(.connectionProblem)))
    }
}
