//
//  ItemEditViewModelState.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import Foundation

enum ItemEditViewModelState {
    case initial
    case add(IndexPath)
    case delete(IndexPath)
}
