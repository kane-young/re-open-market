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
}
