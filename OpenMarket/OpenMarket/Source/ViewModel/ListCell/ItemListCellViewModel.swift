//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

final class ItemListCellViewModel {
    // MARK: State
    enum State {
        case empty
        case update(ItemListCellViewModel.MetaData)
        case error(ItemListCellViewModelError)
    }

    // MARK: MetaData
    struct MetaData {
        var thumbnail: UIImage?
        let title: String
        let isneededDiscountedLabel: Bool
        let discountedPrice: NSAttributedString
        let originalPrice: String
        let stockLabelTextColor: UIColor
        let stock: String
    }

    // MARK: Properties
    private let item: Item
    private let useCase: ImageNetworkUseCaseProtocol
    private var imageTask: URLSessionDataTask?
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

    init(item: Item, useCase: ImageNetworkUseCaseProtocol = ImageNetworkUseCase.shared) {
        self.item = item
        self.useCase = useCase
    }

    // MARK: Instance Method
    func bind(_ handler: @escaping (State) -> Void) {
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

    private func updateText() {
        let isneededDiscountedLabel = item.discountedPrice == nil
        let discountedPrice = discountedPriceText(isneededDiscountedLabel)
        let originalPrice = originalPriceText(isneededDiscountedLabel)
        let stockLabelTextColor: UIColor = item.stock == 0 ?
            Format.Stock.soldOutColor : Format.Stock.defaultColor
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
            return Format.Stock.soldOutText
        } else if count >= Format.Stock.standardCount {
            return Format.Stock.excessiveStockText
        } else {
            return "\(Format.Stock.preText)\(count)"
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
    // MARK: Format
    private enum Format {
        enum Stock {
            static let standardCount: Int = 1000
            static let soldOutColor: UIColor = .systemYellow
            static let defaultColor: UIColor = .label
            static let soldOutText: String = "품절"
            static let preText: String = "수량 : "
            static let excessiveStockText: String = "\(preText)999+"
        }
    }
}
