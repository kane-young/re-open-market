//
//  ItemDetailViewModelState.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import Foundation

enum ItemDetailViewModelState {
    case initial
    case update(ItemDetailViewModel.MetaData)
    case itemNetworkError(ItemNetworkUseCaseError)
    case thumbnailNetworkError(ThumbnailUseCaseError)
    case loadImage([IndexPath])
}
