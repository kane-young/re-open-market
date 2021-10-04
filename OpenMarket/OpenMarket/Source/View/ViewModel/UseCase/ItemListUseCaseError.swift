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

    var message: String {
        switch self {
        case .networkError(let error):
            return "Networking Error - \(error)"
        case .decodingError:
            return "Decoding Error"
        case .referenceCountingZero:
            return "Reference Counting zero - 메모리 해제"
        }
    }
}

extension ItemListUseCaseError: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
