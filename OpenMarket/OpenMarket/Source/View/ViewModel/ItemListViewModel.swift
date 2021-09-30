//
//  MarketItemsViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/27.
//

import UIKit

final class ItemListViewModel {
    private let useCase: ItemListNetworkUseCaseProtocol
    private(set) var items: [ItemList.Item] = [] {
        didSet {
            let indexPath = (oldValue.count..<items.count).map { IndexPath(item: $0, section: 0) }
            if oldValue.count == 0 {
                state = .initial(indexPath)
            } else {
                state = .update(indexPath)
            }
        }
    }
    private var handler: ((ItemListViewModelState) -> Void)?
    private var state: ItemListViewModelState = .empty {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else { return }
                self?.handler?(state)
            }
        }
    }

    init(useCase: ItemListNetworkUseCaseProtocol = ItemListNetworkUseCase()) {
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
