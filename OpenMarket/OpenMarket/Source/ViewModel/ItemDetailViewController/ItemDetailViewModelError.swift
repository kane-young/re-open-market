//
//  ItemDetailViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import Foundation

enum ItemDetailViewModelError: Error {
    case useCaseError(ItemNetworkUseCaseError)
}
