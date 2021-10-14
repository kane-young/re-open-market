//
//  ItemNetworkUseCaseError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import Foundation

enum ItemNetworkUseCaseError: Error {
    case decodingError
    case networkError(NetworkError)
}
