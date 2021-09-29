//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

enum ItemListCellViewModelState {
    case empty
    case update(ItemListCellViewModel.MetaData)
    case error(ItemListCellViewModelError)
}

enum ItemListCellViewModelError {
    case emptyPath
    case invalidURL
    case useCaseError(ThumbnailUseCaseError)
}

final class ItemListCellViewModel {
    struct MetaData {
        var image: UIImage?
        let title: String
        let isneededDiscountedLabel: Bool
        let discountedPrice: NSAttributedString
        let originalPrice: String
        let stockLabelTextColor: UIColor
        let stock: String
    }

    private let marketItem: ItemList.Item
    private let useCase: ThumbnailUseCaseType
    private var imageTask: URLSessionDataTask?
    private var handler: ((ItemListCellViewModelState) -> Void)?
    private var state: ItemListCellViewModelState = .empty {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else {
                    return
                }
                self?.handler?(state)
            }
        }
    }

    init(marketItem: ItemList.Item, useCase: ThumbnailUseCaseType = ThumbnailUseCase()) {
        self.marketItem = marketItem
        self.useCase = useCase
    }

    func bind(_ handler: @escaping (ItemListCellViewModelState) -> Void) {
        self.handler = handler
    }

    func fire() {
        retrieveImage()
        updateText()
    }

    func retrieveImage() {
        guard let urlString = marketItem.thumbnails.first else {
            state = .error(.emptyPath)
            return
        }
        guard let url = URL(string: urlString) else {
            state = .error(.invalidURL)
            return
        }
        imageTask = useCase.retrieveImage(with: url, completionHandler: { [weak self] result in
            switch result {
            case .success(let image):
                guard case var .update(metaData) = self?.state else {
                    return
                }
                metaData.image = image
                self?.state = .update(metaData)
            case .failure(let error):
                self?.state = .error(.useCaseError(error))
            }
        })
    }

    func cancelImageRequest() {
        imageTask?.cancel()
    }

    private func updateText() {
        let isneededDiscountedLabel = marketItem.discountedPrice == nil
        let discountedPrice: NSAttributedString = discountedPriceText(isneededDiscountedLabel, marketItem.currency, marketItem.price)
        let originalPrice = originalPriceText(isneededDiscountedLabel, marketItem.currency, marketItem.price , marketItem.discountedPrice)
        let stockLabelTextColor: UIColor = marketItem.stock == 0 ? .systemYellow : .black
        let stock = stockText(marketItem.stock)
        let metaData = MetaData(image: nil, title: marketItem.title, isneededDiscountedLabel: isneededDiscountedLabel, discountedPrice: discountedPrice, originalPrice: originalPrice, stockLabelTextColor: stockLabelTextColor, stock: stock)
        state = .update(metaData)
    }

    private func stockText(_ count: Int) -> String {
        if count == 0 {
            return "품절"
        } else if count >= 1000 {
            return "수량 : 999+"
        } else {
            return "수량 : \(count)"
        }
    }

    private func originalPriceText(_ isneeded: Bool, _ currency: String, _ price: Int, _ discountedPrice: Int?) -> String {
        let text = currency + " " + (isneeded ? converToMoneyType(price) : converToMoneyType(discountedPrice ?? 0))
        return text
    }

    private func discountedPriceText(_ isneeded: Bool, _ currency: String, _ price: Int) -> NSAttributedString {
        let price = converToMoneyType(price)
        return isneeded ? .init() : "\(currency) \(price)".strikeThrough()
    }

    private func converToMoneyType(_ price: Int) -> String {
        let price = NSNumber(value: price)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let text = formatter.string(from: price) else {
            return .init()
        }
        return text
    }
}
