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
        case error(ItemDetailPhotoCellViewModelError)
    }

    // MARK: Properties
    private let imagePath: String
    private var handler: ((State) -> Void)?
    private let useCase: ImageNetworkUseCaseProtocol
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

    init(imagePath: String, useCase: ImageNetworkUseCaseProtocol = ImageNetworkUseCase.shared) {
        self.imagePath = imagePath
        self.useCase =  useCase
    }

    // MARK: Instance Method
    func bind(_ handler: @escaping (State) -> Void) {
        self.handler = handler
    }

    func configureCell() {
        useCase.retrieveImage(with: imagePath) { [weak self] result in
            switch result {
            case .success(let image):
                self?.state = .update(image)
            case .failure(let error):
                self?.state = .error(.useCase(error))
            }
        }
    }
}
