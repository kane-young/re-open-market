//
//  ItemDetailCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import UIKit

final class ItemDetailCellViewModel {
    private let image: UIImage
    private var handler: ((ItemPhotoCellViewModelState) -> Void)?
    private var state: ItemPhotoCellViewModelState = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else {
                    return
                }
                self?.handler?(state)
            }
        }
    }

    init(image: UIImage) {
        self.image = image
    }

    func bind(_ handler: @escaping (ItemPhotoCellViewModelState) -> Void) {
        self.handler = handler
    }

    func configureCell() {
        state = .update(image)
    }
}
