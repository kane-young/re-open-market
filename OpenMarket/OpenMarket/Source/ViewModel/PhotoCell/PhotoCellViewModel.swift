//
//  ItemPhotoCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import UIKit

final class PhotoCellViewModel {
    // MARK: State
    enum State {
        case empty
        case update(UIImage)
    }

    // MARK: Properties
    private let image: UIImage
    private var handler: ((State) -> Void)?
    private var state: State = .empty {
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
