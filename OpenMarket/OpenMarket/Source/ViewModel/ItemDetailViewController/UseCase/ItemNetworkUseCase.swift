//
//  ItemNetworkUseCase.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import Foundation

final class ItemNetworkUseCase: ItemNetworkUseCaseProtocol {
    private let networkManager: NetworkManagable

    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func retrieveItem(id: Int, completionHandler: @escaping (Result<Item, ItemNetworkUseCaseError>) -> Void) {
        let path = OpenMarketAPI.loadProduct(id: id).urlString
        networkManager.request(urlString: path, with: nil, httpMethod: .get) { result in
            switch result {
            case .success(let data):
                guard let item = try? JSONDecoder().decode(Item.self, from: data) else {
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
