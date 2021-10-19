//
//  ItemEditNetoworkUseCaseProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/15.
//

import Foundation

protocol ItemEditNetworkUseCaseProtocol {
    func request(path urlString: String, with item: Multipartable?, for httpMethod: HttpMethod,
                 completionHandler: @escaping (Result<Item, ItemEditUseCaseError>) -> Void)
}
