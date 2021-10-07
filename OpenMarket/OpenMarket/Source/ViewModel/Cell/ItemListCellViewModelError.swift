//
//  ItemListCellViewModelError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import Foundation

enum ItemListCellViewModelError: Error {
    case emptyPath
    case useCaseError(ThumbnailUseCaseError)

    var message: String {
        switch self {
        case .emptyPath:
            return "URL 주소 존재하지 않음"
        case .useCaseError(let error):
            return "UseCase 에러 발생 \(error.message)"
        }
    }
}

extension ItemListCellViewModelError: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
