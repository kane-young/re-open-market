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
        case delete
        case update(MetaData)
        case error(ItemDetailViewModelError)
    }

    // MARK: MetaData
    struct MetaData {
        let title: String
        let price: NSAttributedString
        let priceLabelTextColor: UIColor
        let discountedPrice: String
        let isNeededDiscountedLabel: Bool
        let stock: String
        let stockLabelTextColor: UIColor
        let descriptions: String
    }

    // MARK: Properties
    private(set) var id: Int
    private let itemNetworkUseCase: ItemNetworkUseCaseProtocol
    private let imageNetworkUseCase: ImageNetworkUseCase = .shared
    private var handler: ((State) -> Void)?
    private var state: State = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else { return }
                self?.handler?(state)
            }
        }
    }
    private(set) var images: [UIImage] = []

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
                self.loadImages(item: item)
            case .failure(let error):
                self.state = .error(.useCaseError(error))
            }
        }
    }

    private func loadImages(item: Item) {
        let dispatchGroup = DispatchGroup()
        guard let imagePaths = item.images else { return }
        var images: [UIImage] = Array(repeating: UIImage(), count: imagePaths.count)
        for index in .zero..<imagePaths.count {
            dispatchGroup.enter()
            DispatchQueue(label: "ImageLoadQueue", attributes: .concurrent).async(group: dispatchGroup) { [weak self] in
                self?.imageNetworkUseCase.retrieveImage(with: imagePaths[index]) { result in
                    switch result {
                    case .success(let image):
                        images[index] = image
                        dispatchGroup.leave()
                    case .failure(let error):
                        self?.state = .error(.imageUseCaseError(error))
                    }
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let metaData = self?.metaData(for: item) else { return }
            self?.images.append(contentsOf: images)
            self?.state = .update(metaData)
        }
    }

    func reset() {
        images.removeAll()
        loadItem()
    }

    private func metaData(for item: Item) -> MetaData {
        let isNeededDiscountedLabel: Bool = item.discountedPrice != nil ? true: false
        let descriptions = item.descriptions ?? ""
        let metaData = MetaData(title: item.title,
                                price: self.originalPriceText(item: item),
                                priceLabelTextColor: self.priceLabelTextColor(item: item),
                                discountedPrice: self.discountedPriceText(item),
                                isNeededDiscountedLabel: isNeededDiscountedLabel,
                                stock: self.convertStockText(item),
                                stockLabelTextColor: self.stockLabelTextColor(item: item),
                                descriptions: descriptions)
        return metaData
    }

    func deleteItem(password: String) {
        itemNetworkUseCase.deleteItem(id: id, password: password) { result in
            switch result {
            case .failure(let error):
                self.state = .error(.useCaseError(error))
            default:
                self.state = .delete
            }
        }
    }

    private func priceLabelTextColor(item: Item) -> UIColor {
        return item.discountedPrice != nil ? Format.Price.stressedColor : Format.Price.defaultColor
    }

    private func stockLabelTextColor(item: Item) -> UIColor {
        if item.stock == .zero {
            return Format.Stock.soldOutColor
        } else {
            return Format.Stock.defaultColor
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
        enum Price {
            static let defaultColor: UIColor = .label
            static let stressedColor: UIColor = .systemRed
        }
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
