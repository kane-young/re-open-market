//
//  ItemEditViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/15.
//

import Foundation

enum ItemEditViewModelError: Error, ComprehensibleError {
    case useCaseError(ItemEditUseCaseError)

    var message: String {
        switch self {
        case .useCaseError(let error):
            return "UseCase \(error.message)"
        }
    }
}
