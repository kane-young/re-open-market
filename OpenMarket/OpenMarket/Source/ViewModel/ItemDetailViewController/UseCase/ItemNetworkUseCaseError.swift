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
            return "Decoding Error"
        case .networkError(let error):
            return "Networking Error - \(error.message)"
        }
    }
}

extension ItemNetworkUseCaseError: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
