//
//  ItemEditNetworkUseCase.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/15.
//

import Foundation

final class ItemEditNetworkUseCase: ItemEditNetworkUseCaseProtocol {
    private let networkManager: NetworkManagable
    private let decoder: JSONDecoder = .init()

    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func request(path urlString: String, with item: Multipartable?, for httpMethod: HttpMethod, completionHandler: @escaping (Result<Item, ItemEditUseCaseError>) -> Void) {
        networkManager.request(urlString: urlString, with: item, httpMethod: httpMethod) { [weak self] result in
            switch result {
            case .success(let data):
                guard let item = try? self?.decoder.decode(Item.self, from: data) else {
                    completionHandler(.failure(.decodingError))
                    return
                }
                completionHandler(.success(item))
            case .failure(let error):
                completionHandler(.failure(.networkError(error)))
            }
        }
    }
}
