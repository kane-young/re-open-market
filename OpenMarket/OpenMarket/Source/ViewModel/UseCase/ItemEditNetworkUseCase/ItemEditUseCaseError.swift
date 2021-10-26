//
//  ItemEditUseCaseError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/15.
//

import Foundation

enum ItemEditUseCaseError: Error {
    case decodingError
    case networkError(NetworkError)

    var message: String {
        switch self {
        case .decodingError:
            return "Decoding 에러 발생"
        case .networkError(let error):
            return "Networking Error - \(error.message)"
        }
    }
}
