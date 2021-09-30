//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

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
    private let useCase: ThumbnailUseCaseProtocol
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

    init(marketItem: ItemList.Item, useCase: ThumbnailUseCaseProtocol = ThumbnailUseCase()) {
        self.marketItem = marketItem
        self.useCase = useCase
    }

    func bind(_ handler: @escaping (ItemListCellViewModelState) -> Void) {
        self.handler = handler
    }

    func configureCell() {
        updateText()
        retrieveImage()
    }

    private func retrieveImage() {
        guard let urlString = marketItem.thumbnails.first else {
            state = .error(.emptyPath)
            return
        }
        imageTask = useCase.retrieveImage(with: urlString, completionHandler: { [weak self] result in
            switch result {
            case .success(let image):
                guard case var .update(metaData) = self?.state else { return }
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
        let discountedPrice = discountedPriceText(isneededDiscountedLabel)
        let originalPrice = originalPriceText(isneededDiscountedLabel)
        let stockLabelTextColor: UIColor = marketItem.stock == 0 ? .systemYellow : .black
        let stock = stockText(marketItem.stock)
        let metaData = MetaData(image: nil,
                                title: marketItem.title,
                                isneededDiscountedLabel: isneededDiscountedLabel,
                                discountedPrice: discountedPrice,
                                originalPrice: originalPrice,
                                stockLabelTextColor: stockLabelTextColor,
                                stock: stock)
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

    private func originalPriceText(_ isneededDiscountedLabel: Bool) -> String {
        let price = isneededDiscountedLabel ? converToMoneyType(marketItem.price) : converToMoneyType(marketItem.discountedPrice ?? 0)
        let text = marketItem.currency + " " + price
        return text
    }

    private func discountedPriceText(_ isneededDiscountedLabel: Bool) -> NSAttributedString {
        let price = converToMoneyType(marketItem.price)
        return isneededDiscountedLabel ? .init() : "\(marketItem.currency) \(price)".strikeThrough()
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
