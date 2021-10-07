//
//  ItemListNetworkUseCaseProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

protocol ItemListNetworkUseCaseProtocol {
    func retrieveItems(completionHandler: @escaping (Result<[ItemList.Item], ItemListUseCaseError>) -> Void)
}
