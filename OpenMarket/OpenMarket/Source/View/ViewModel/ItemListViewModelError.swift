//
//  ItemListViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

enum ItemListViewModelError: Error {
    case useCaseError(ItemListUseCaseError)
}
