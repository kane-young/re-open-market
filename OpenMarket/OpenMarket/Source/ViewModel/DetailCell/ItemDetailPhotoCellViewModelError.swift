//
//  ItemDetailPhotoCellViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/17.
//

import Foundation

enum ItemDetailPhotoCellViewModelError: Error {
    case useCase(ImageNetworkUseCaseError)

    var message: String {
        switch self {
        case .useCase(let error):
            return "UseCase \(error.message)"
        }
    }
}
