//
//  ItemListNetworkUseCaseError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

enum ItemListUseCaseError: Error {
    case networkError(NetworkError)
    case decodingError
    case referenceCountingZero
}
