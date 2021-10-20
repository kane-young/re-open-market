//
//  ItemDetailViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import Foundation

enum ItemDetailViewModelError: Error, ComprehensibleError {
    case useCaseError(ItemNetworkUseCaseError)
    case imageUseCaseError(ImageNetworkUseCaseError)

    var message: String {
        switch self {
        case .useCaseError(let error):
            return "UseCase \(error.message)"
        case .imageUseCaseError(let error):
            return "Image UseCase \(error.message)"
        }
    }
}

extension ItemDetailViewModelError: Equatable {
    static func == (lhs: ItemDetailViewModelError, rhs: ItemDetailViewModelError) -> Bool {
        return lhs.message == rhs.message
    }
}
