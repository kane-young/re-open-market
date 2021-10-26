//
//  ItemEditUseCaseError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/15.
//

import Foundation

enum ItemEditNetworkUseCaseError: Error {
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

extension ItemEditNetworkUseCaseError: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
