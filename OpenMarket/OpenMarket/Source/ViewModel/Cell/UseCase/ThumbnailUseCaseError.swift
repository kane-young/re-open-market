//
//  ThumbnailUseCaseError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

enum ThumbnailUseCaseError: Error {
    case networkError(NetworkError)
    case convertDataToImageError
    case invalidURL

    var message: String {
        switch self {
        case .networkError(let error):
            return "Networking Error - \(error.message)"
        case .convertDataToImageError:
            return "Can't convert Data to Image error"
        case .invalidURL:
            return "Invalid URL 주소"
        }
    }
}

extension ThumbnailUseCaseError: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
