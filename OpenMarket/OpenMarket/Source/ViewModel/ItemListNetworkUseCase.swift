//
//  ItemListNetworkUseCase.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import Foundation

enum ItemListUseCaseError: Error {
    case networkError(NetworkError)
    case decodingError
    case referenceCountingZero
}

protocol ItemListUseCaseType {
    func retrieveItems(completionHandler: @escaping (Result<[ItemList.Item], ItemListUseCaseError>) -> Void)
}

final class ItemListNetworkUseCase: ItemListUseCaseType {
    private let networkManager: NetworkManagable
    private let decoder: JSONDecoder = JSONDecoder()
    private var page: Int = 1
    private var isLoading: Bool = false

    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func retrieveItems(completionHandler: @escaping (Result<[ItemList.Item], ItemListUseCaseError>) -> Void) {
        guard let url = OpenMarketAPI.load(page: page).url else {
            return
        }

        if isLoading {
            return
        }

        isLoading = true
        _ = networkManager.fetch(url: url) { [weak self] result in
            let result = result.flatMapError { .failure(ItemListUseCaseError.networkError($0)) }
                .flatMap { data -> Result<[ItemList.Item], ItemListUseCaseError> in
                    do {
                        guard let itemList = try self?.decoder.decode(ItemList.self, from: data) else {
                            return .failure(ItemListUseCaseError.referenceCountingZero)
                        }
                        self?.page = itemList.page + 1
                        return .success(itemList.items)
                    } catch {
                        return .failure(ItemListUseCaseError.decodingError)
                    }
                }
            completionHandler(result)
            self?.isLoading = false
        }
    }
}