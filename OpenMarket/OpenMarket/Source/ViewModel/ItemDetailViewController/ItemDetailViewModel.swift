//
//  ItemDetailViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/14.
//

import UIKit

final class ItemDetailViewModel {
    // MARK: State
    enum State {
        case initial
        case update(MetaData)
        case itemNetworkError(ItemDetailViewModelError)
    }

    // MARK: MetaData
    struct MetaData {
        let title: String
        let price: NSAttributedString
        let discountedPrice: String
        let isNeededDiscountedLabel: Bool
        let stock: String
        let descriptions: String
        let imageCount: Int
        let isSoldOut: Bool
    }

    // MARK: Properties
    private let id: Int
    private let itemNetworkUseCase: ItemNetworkUseCaseProtocol
    private var handler: ((State) -> Void)?
    private(set) var images: [String] = []
    private var state: State = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else { return }
                self?.handler?(state)
            }
        }
    }

    init(id: Int, itemNetworkUseCase: ItemNetworkUseCaseProtocol = ItemNetworkUseCase()) {
        self.id = id
        self.itemNetworkUseCase = itemNetworkUseCase
    }

    // MARK: Instance Method
    func bind(handler: @escaping (State) -> Void) {
        self.handler = handler
    }

    func loadItem() {
        itemNetworkUseCase.retrieveItem(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let item):
                guard let images = item.images else { return }
                self.images.append(contentsOf: images)
                let isNeededDiscountedLabel: Bool = item.discountedPrice != nil ? true: false
                guard let descriptions = item.descriptions else { return }
                let metaData = MetaData(title: item.title,
                                        price: self.originalPriceText(item: item),
                                        discountedPrice: self.discountedPriceText(item),
                                        isNeededDiscountedLabel: isNeededDiscountedLabel,
                                        stock: self.convertStockText(item),
                                        descriptions: descriptions,
                                        imageCount: images.count,
                                        isSoldOut: item.stock == .zero ? true : false)
                self.state = .update(metaData)
            case .failure(let error):
                self.state = .itemNetworkError(.useCaseError(error))
            }
        }
    }

    private func originalPriceText(item: Item) -> NSAttributedString {
        let isNeededDiscountedLabel = item.discountedPrice != nil ? true : false
        let defaultText = "\(item.currency) \(converToMoneyType(item.price))"
        let strikeThuroughText = defaultText.strikeThrough()
        let normalText = NSAttributedString(string: defaultText)
        let text = isNeededDiscountedLabel ? strikeThuroughText : normalText
        return text
    }

    private func discountedPriceText(_ item: Item) -> String {
        if let discountedPrice = item.discountedPrice {
            let price = converToMoneyType(discountedPrice)
            return "\(item.currency) \(price)"
        } else {
            return .init()
        }
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

    private func convertStockText(_ item: Item) -> String {
        let stock = item.stock
        if stock == .zero {
            return Format.Stock.soldOutText
        } else if stock >= Format.Stock.standardCount {
            return Format.Stock.excessiveStockText
        } else {
            return Format.Stock.preText + "\(stock)"
        }
    }
}

extension ItemDetailViewModel {
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
