//
//  ItemDetailCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import UIKit

final class ItemDetailCellViewModel {
    private let imagePath: String
    private var handler: ((ItemPhotoCellViewModelState) -> Void)?
    private let useCase: ThumbnailUseCaseProtocol
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

    init(imagePath: String, useCase: ThumbnailUseCaseProtocol = ThumbnailUseCase.shared) {
        self.imagePath = imagePath
        self.useCase =  useCase
    }

    func bind(_ handler: @escaping (ItemPhotoCellViewModelState) -> Void) {
        self.handler = handler
    }

    func configureCell() {
        useCase.retrieveImage(with: imagePath) { [weak self] result in
            switch result {
            case .success(let image):
                self?.state = .update(image)
            case .failure(_):
                print("실패")
            }
        }
    }
}
