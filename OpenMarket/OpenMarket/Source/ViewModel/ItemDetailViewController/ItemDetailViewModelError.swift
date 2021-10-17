//
//  ItemDetailViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import Foundation

enum ItemDetailViewModelError: Error, ComprehensibleError {
    case useCaseError(ItemNetworkUseCaseError)

    var message: String {
        switch self {
        case .useCaseError(let error):
            return "UseCase \(error.message)"
        }
    }
}
