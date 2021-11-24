//
//  ItemEditViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import UIKit

final class ItemEditViewModel {
    // MARK: State
    enum State {
        case empty
        case loading
        case initial(Item)
        case addPhoto(IndexPath)
        case deletePhoto(IndexPath)
        case satisfied
        case dissatisfied
        case register(Item)
        case update(Item)
        case error(ItemEditViewModelError)
    }

    // MARK: Properties
    private(set) var currencies: [String] = ["KRW", "JPY", "USD", "EUR", "CNY", "BTC"].sorted()
    private(set) var images: [UIImage] = []
    private let id: Int?
    private var title: String?
    private var stock: Int?
    private var currency: String?
    private var price: Int?
    private var discountedPrice: Int?
    private var descriptions: String?
    private var password: String?
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
    private var handler: ((State) -> Void)?
    private let itemEditNetworkUseCase: ItemEditNetworkUseCaseProtocol
    private let imageNetworkUseCase: ImageNetworkUseCaseProtocol

    init(id: Int? = nil, itemEditNetworkUseCase: ItemEditNetworkUseCaseProtocol = ItemEditNetworkUseCase(),
         imageNetworkUseCase: ImageNetworkUseCaseProtocol = ImageNetworkUseCase.shared) {
        self.id = id
        self.itemEditNetworkUseCase = itemEditNetworkUseCase
        self.imageNetworkUseCase = imageNetworkUseCase
    }

    // MARK: Instance Method
    func bind(_ handler: @escaping (State) -> Void) {
        self.handler = handler
    }

    func addImage(_ image: UIImage?) {
        if let image = image {
            images.append(image)
        }
        state = .addPhoto(IndexPath(item: images.count, section: 0))
    }

    func deleteImage(_ indexPath: IndexPath) {
        images.remove(at: indexPath.item-1)
        state = .deletePhoto(indexPath)
    }

    func validate(titleText: String?, stockText: String?, currencyText: String?, priceText: String?,
                  discountedPriceText: String?, descriptionsText: String?) {
        if let discountedPriceText = discountedPriceText, let discountedPrice = Int(discountedPriceText),
           let priceText = priceText, let price = Int(priceText) {
            if discountedPrice < price {
                self.discountedPrice = discountedPrice
            } else {
                state = .dissatisfied
                return
            }
        }
        if !images.isEmpty, let title = titleText, let stock = stockText, let currency = currencyText,
           let price = priceText, let descriptions = descriptionsText,
           descriptions != ItemEditViewController.Style.DescriptionsTextView.placeHolder {
            self.title = title
            self.stock = Int(stock)
            self.currency = currency
            self.price = Int(price)
            self.descriptions = descriptions
            state = .satisfied
        } else {
            state = .dissatisfied
        }
    }

    func registerItem(password: String) {
        state = .loading
        let imageDatas = images.map { $0.compress(target: 300) }
        guard let title = title, let stock = stock, let currency = currency, let price = price, let descriptions = descriptions else {
            return
        }
        let postItem = PostItem(title: title, descriptions: descriptions, price: price, currency: currency, stock: stock, discountedPrice: discountedPrice, images: imageDatas, password: password)
        itemEditNetworkUseCase.request(path: OpenMarketAPI.postProduct.urlString, with: postItem, for: .post) {
            [weak self] result in
            switch result {
            case .success(let item):
                self?.state = .register(item)
            case .failure(let error):
                self?.state = .error(.editUseCaseError(error))
            }
        }
    }

    func loadItem() {
        guard let id = id else { return }
        let path = OpenMarketAPI.loadProduct(id: id).urlString
        itemEditNetworkUseCase.request(path: path, with: nil, for: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let item):
                self.loadImages(item: item)
            case .failure(let error):
                self.state = .error(.editUseCaseError(error))
            }
        }
    }

    private func loadImages(item: Item) {
        let queue = DispatchQueue(label: "ImagesLoadQueue", attributes: .concurrent)
        let dispatchGroup = DispatchGroup()
        guard let imagePaths = item.images else { return }
        var images: [UIImage] = Array(repeating: UIImage(), count: imagePaths.count)
        for index in .zero..<imagePaths.count {
            dispatchGroup.enter()
            queue.async(group: dispatchGroup) { [weak self] in
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
            self?.images.append(contentsOf: images)
            self?.state = .initial(item)
        }
    }

    func updateItem(password: String) {
        state = .loading
        let imageDatas = images.map { $0.compress(target: 300) }
        guard let title = title, let stock = stock, let currency = currency, let price = price, let descriptions = descriptions else {
            return
        }
        let updateItem = PatchItem(title: title, descriptions: descriptions, price: price, currency: currency, stock: stock, discountedPrice: discountedPrice, images: imageDatas, password: password)
        guard let id = id else { return }
        let path = OpenMarketAPI.patchProduct(id: id).urlString
        itemEditNetworkUseCase.request(path: path, with: updateItem, for: .patch) { [weak self] result in
            switch result {
            case .success(let item):
                self?.state = .update(item)
            case .failure(let error):
                self?.state = .error(.editUseCaseError(error))
            }
        }
    }
}
