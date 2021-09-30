//
//  ItemListCellViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

enum ItemListCellViewModelError {
    case emptyPath
    case useCaseError(ThumbnailUseCaseError)
}
