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

    var message: String {
        switch self {
        case .decodingError:
            return "디코딩 에러"
        case .networkError(let error):
            return "UseCase \(error.message)"
        }
    }
}
