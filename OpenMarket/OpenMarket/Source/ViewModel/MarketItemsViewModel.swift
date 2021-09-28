//
//  MarketItemsViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/27.
//

import UIKit

enum ItemListViewModelState {
    case initial
    case update([IndexPath])
    case error(ItemListViewModelError)
}

enum ItemListViewModelError: Error {
    case useCaseError(ItemListUseCaseError)
}

final class ItemListViewModel {
    private let useCase: ItemListUseCaseType
    private(set) var items: [ItemList.Item] = [] {
        didSet {
            let indexPath = (oldValue.count..<items.count).map { IndexPath(item: $0, section: 0) }
            state = .update(indexPath)
        }
    }
    private var handler: ((ItemListViewModelState) -> Void)?
    private var state: ItemListViewModelState = .initial {
        didSet {
            handler?(state)
        }
    }

    init(useCase: ItemListUseCaseType = ItemListNetworkUseCase()) {
        self.useCase = useCase
    }

    func bind(handler: @escaping (ItemListViewModelState) -> Void) {
        self.handler = handler
    }

    func loadPage() {
        useCase.retrieveItems { [weak self] result in
            switch result {
            case .success(let marketItems):
                self?.items.append(contentsOf: marketItems)
            case .failure(let error):
                self?.state = .error(.useCaseError(error))
            }
        }
    }
}
