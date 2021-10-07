//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

final class ItemListCellViewModel {
    struct MetaData {
        var thumbnail: UIImage?
        let title: String
        let isneededDiscountedLabel: Bool
        let discountedPrice: NSAttributedString
        let originalPrice: String
        let stockLabelTextColor: UIColor
        let stock: String
    }

    private let item: ItemList.Item
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

    init(item: ItemList.Item, useCase: ThumbnailUseCaseProtocol = ThumbnailUseCase.shared) {
        self.item = item
        self.useCase = useCase
    }

    func bind(_ handler: @escaping (ItemListCellViewModelState) -> Void) {
        self.handler = handler
    }

    func configureCell() {
        updateText()
        loadImage()
    }

    private func loadImage() {
        guard let urlString = item.thumbnails.first else {
            state = .error(.emptyPath)
            return
        }
        imageTask = useCase.retrieveImage(with: urlString, completionHandler: { [weak self] result in
            switch result {
            case .success(let image):
                guard case var .update(metaData) = self?.state else { return }
                metaData.thumbnail = image
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
        let isneededDiscountedLabel = item.discountedPrice == nil
        let discountedPrice = discountedPriceText(isneededDiscountedLabel)
        let originalPrice = originalPriceText(isneededDiscountedLabel)
        let stockLabelTextColor: UIColor = item.stock == 0 ?
            Format.Stock.outOfStockColor : Format.Stock.defaultStockColor
        let stock = stockText(item.stock)
        let metaData = MetaData(thumbnail: nil,
                                title: item.title,
                                isneededDiscountedLabel: isneededDiscountedLabel,
                                discountedPrice: discountedPrice,
                                originalPrice: originalPrice,
                                stockLabelTextColor: stockLabelTextColor,
                                stock: stock)
        state = .update(metaData)
    }

    private func stockText(_ count: Int) -> String {
        if count == .zero {
            return Format.Stock.outOfStockText
        } else if count >= Format.Stock.standardCount {
            return Format.Stock.excessiveStockText
        } else {
            return "\(Format.Stock.format)\(count)"
        }
    }

    private func originalPriceText(_ isneededDiscountedLabel: Bool) -> String {
        let price = isneededDiscountedLabel ? converToMoneyType(item.price) : converToMoneyType(item.discountedPrice ?? .zero)
        let text = item.currency + " " + price
        return text
    }

    private func discountedPriceText(_ isneededDiscountedLabel: Bool) -> NSAttributedString {
        let price = converToMoneyType(item.price)
        return isneededDiscountedLabel ? .init() : "\(item.currency) \(price)".strikeThrough()
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

extension ItemListCellViewModel {
    private enum Format {
        enum Stock {
            static let standardCount: Int = 1000
            static let outOfStockColor: UIColor = .systemYellow
            static let defaultStockColor: UIColor = .label
            static let outOfStockText: String = "품절"
            static let format: String = "수량 : "
            static let excessiveStockText: String = "\(format)999+"
        }
    }
}
