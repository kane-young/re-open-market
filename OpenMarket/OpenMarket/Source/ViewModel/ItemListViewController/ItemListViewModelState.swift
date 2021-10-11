//
//  ItemListViewModelState.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

enum ItemListViewModelState {
    case empty
    case initial([IndexPath])
    case update([IndexPath])
    case error(ItemListViewModelError)
}
