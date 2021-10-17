//
//  ItemListViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

enum ItemListViewModelError: Error, ComprehensibleError {
    case useCaseError(ItemListUseCaseError)

    var message: String {
        switch self {
        case .useCaseError(let error):
            return "UseCase \(error.message)"
        }
    }
}
