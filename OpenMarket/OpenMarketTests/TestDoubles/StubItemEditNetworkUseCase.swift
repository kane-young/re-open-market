//
//  StubItemEditNetworkUseCase.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/25.
//

import Foundation
@testable import OpenMarket

final class StubSuccessItemEditNetworkUseCase: ItemEditNetworkUseCaseProtocol {
    func request(path urlString: String, with item: Multipartable?, for httpMethod: HttpMethod, completionHandler: @escaping (Result<Item, ItemEditNetworkUseCaseError>) -> Void) {
        let item = Item(id: 50, title: "itemTitle", descriptions: "Descriptions", price: 50000,
                        currency: "KRW", stock: 11, discountedPrice: 5000, thumbnails: ["https://www.kane.com"],
                        images: ["https://www.kane.com"], registrationDate: 123455)
        completionHandler(.success(item))
    }
}

final class StubFailureItemEditNetworkUseCase: ItemEditNetworkUseCaseProtocol {
    func request(path urlString: String, with item: Multipartable?, for httpMethod: HttpMethod, completionHandler: @escaping (Result<Item, ItemEditNetworkUseCaseError>) -> Void) {
        completionHandler(.failure(.networkError(.connectionProblem)))
    }
}
