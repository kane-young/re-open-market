//
//  ItemDetailCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import UIKit

final class ItemDetailPhotoCellViewModel {
    // MARK: State
    enum State {
        case initial
        case update(UIImage)
    }

    // MARK: Properties
    private let image: UIImage
    private var handler: ((State) -> Void)?
    private var state: State = .initial {
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

    // MARK: Instance Method
    func bind(_ handler: @escaping (State) -> Void) {
        self.handler = handler
    }

    func configureCell() {
        state = .update(image)
    }
}
