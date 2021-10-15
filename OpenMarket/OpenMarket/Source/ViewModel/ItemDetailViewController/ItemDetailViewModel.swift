//
//  ItemDetailViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import UIKit

final class ItemDetailViewModel {
    struct MetaData {
        let title: String
        let price: String
        let discountedPrice: String?
        let isNeededDiscountedLabel: Bool
        let stock: String
        let descriptions: String
    }

    private let id: Int
    private let itemNetworkUseCase: ItemNetworkUseCaseProtocol
    private let imageNetworkUseCase: ThumbnailUseCaseProtocol
    private var handler: ((ItemDetailViewModelState) -> Void)?
    private(set) var images: [UIImage] = [] {
        didSet {
            let indexPaths = (oldValue.count..<images.count).map { IndexPath(item: $0, section: 0) }
            state = .loadImage(indexPaths)
        }
    }
    private var state: ItemDetailViewModelState = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else { return }
                self?.handler?(state)
            }
        }
    }

    init(id: Int, itemNetworkUseCase: ItemNetworkUseCaseProtocol = ItemNetworkUseCase(), imageNetworkUseCase: ThumbnailUseCaseProtocol = ThumbnailUseCase.shared) {
        self.id = id
        self.itemNetworkUseCase = itemNetworkUseCase
        self.imageNetworkUseCase = imageNetworkUseCase
    }

    func bind(handler: @escaping (ItemDetailViewModelState) -> Void) {
        self.handler = handler
    }

    func loadItem() {
        itemNetworkUseCase.retrieveItem(id: id) { [weak self] result in
            switch result {
            case .success(let item):
                guard let images = item.images else { return }
                for image in images {
                    OperationQueue().addOperation {
                        self?.imageNetworkUseCase.retrieveImage(with: image) { result in
                            switch result {
                            case .success(let image):
                                self?.images.append(image)
                            case .failure(let error):
                                self?.state = .thumbnailNetworkError(error)
                            }
                        }
                    }
                }
                let metaData = MetaData(title: item.title,
                                        price: String(item.price),
                                        discountedPrice: String(item.discountedPrice ?? 0), isNeededDiscountedLabel: false,
                                        stock: String(item.stock),
                                        descriptions: item.descriptions!)
                self?.state = .update(metaData)
            case .failure(let error):
                self?.state = .itemNetworkError(error)
            }
        }
    }
}
