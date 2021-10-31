//
//  ItemListNetworkUseCase.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import Foundation

final class ItemListNetworkUseCase: ItemListNetworkUseCaseProtocol {
    private let networkManager: NetworkManagable
    private let decoder: JSONDecoder = JSONDecoder()
    private var page: Int = 1
    private var isLoading: Bool = false

    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func reset() {
        page = 1
        isLoading = false
    }

    func retrieveItems(completionHandler: @escaping (Result<[Item], ItemListNetworkUseCaseError>) -> Void) {
        let urlString = OpenMarketAPI.load(page: page).urlString
        if isLoading {
            return
        }
        isLoading = true
        networkManager.request(urlString: urlString, with: nil, httpMethod: .get) { [weak self] result in
            let result = result.flatMapError { .failure(ItemListNetworkUseCaseError.networkError($0)) }
                .flatMap { data -> Result<[Item], ItemListNetworkUseCaseError> in
                    do {
                        guard let itemList = try self?.decoder.decode(ItemList.self, from: data) else {
                            return .failure(ItemListNetworkUseCaseError.referenceCountingZero)
                        }
                        self?.page = itemList.page + 1
                        return .success(itemList.items)
                    } catch {
                        return .failure(ItemListNetworkUseCaseError.decodingError)
                    }
                }
            completionHandler(result)
            self?.isLoading = false
        }
    }
}
