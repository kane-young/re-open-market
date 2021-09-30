//
//  ItemListCellViewModelState.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

enum ItemListCellViewModelState {
    case empty
    case update(ItemListCellViewModel.MetaData)
    case error(ItemListCellViewModelError)
}
