//
//  ItemEditViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/15.
//

import Foundation

enum ItemEditViewModelError: Error, ComprehensibleError {
    case editUseCaseError(ItemEditNetworkUseCaseError)
    case imageUseCaseError(ImageNetworkUseCaseError)

    var message: String {
        switch self {
        case .editUseCaseError(let error):
            return "Item Edit UseCase \(error.message)"
        case .imageUseCaseError(let error):
            return "Image Load UseCase \(error.message)"
        }
    }
}

extension ItemEditViewModelError: Equatable {
    static func == (lhs: ItemEditViewModelError, rhs: ItemEditViewModelError) -> Bool {
        return lhs.message == rhs.message
    }
}
