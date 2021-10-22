//
//  MarketItemsViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/27.
//

import UIKit

final class ItemListViewModel {
    // MARK: State
    enum State {
        case empty
        case initial
        case update([IndexPath])
        case error(ItemListViewModelError)
    }

    // MARK: Properties
    private let useCase: ItemListNetworkUseCaseProtocol
    private(set) var items: [Item] = [] {
        didSet {
            if oldValue.count > items.count { return }
            let indexPaths = (oldValue.count..<items.count).map { IndexPath(item: $0, section: .zero) }
            if oldValue.count == .zero {
                state = .initial
            } else {
                state = .update(indexPaths)
            }
        }
    }
    private var handler: ((State) -> Void)?
    private var state: State = .empty {
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

    // MARK: Instance Method
    func bind(handler: @escaping (State) -> Void) {
        self.handler = handler
    }

    func loadItems() {
        useCase.retrieveItems { [weak self] result in
            switch result {
            case .success(let marketItems):
                self?.items.append(contentsOf: marketItems)
            case .failure(let error):
                self?.state = .error(.useCaseError(error))
            }
        }
    }

    func reset() {
        items.removeAll()
        useCase.reset()
        loadItems()
    }
}
