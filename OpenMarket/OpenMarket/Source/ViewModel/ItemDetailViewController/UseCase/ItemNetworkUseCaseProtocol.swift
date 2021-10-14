//
//  ItemNetworkUseCaseProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import Foundation

protocol ItemNetworkUseCaseProtocol {
    func retrieveItem(id: Int, completionHandler: @escaping (Result<Item, ItemNetworkUseCaseError>) -> Void)
}
