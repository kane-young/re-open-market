//
//  ItemEditViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import UIKit

protocol ItemEditViewModelDelegate: AnyObject {
    func imagesCountChanged(_ count: Int)
}

final class ItemEditViewModel {
    weak var delegate: ItemEditViewModelDelegate?
    let currencies: [String] = ["KRW", "JPY", "USD", "EUR", "CNY"]
    private(set) var images: [UIImage] = [] {
        didSet {
            delegate?.imagesCountChanged(images.count)
        }
    }
    private var state: ItemEditViewModelState = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else {
                    return
                }
                self?.handler?(state)
            }
        }
    }
    private var handler: ((ItemEditViewModelState) -> Void)?

    func bind(_ handler: @escaping (ItemEditViewModelState) -> Void) {
        self.handler = handler
    }

    func addImage(_ image: UIImage?) {
        if let image = image {
            images.append(image)
        }
        state = .add(IndexPath(item: images.count, section: 0))
    }

    func deleteImage(_ indexPath: IndexPath) {
        images.remove(at: indexPath.item-1)
        state = .delete(indexPath)
    }
}
