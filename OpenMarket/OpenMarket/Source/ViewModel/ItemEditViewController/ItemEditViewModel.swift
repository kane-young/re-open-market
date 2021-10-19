//
//  ItemEditViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import UIKit

protocol ItemEditViewModelDelegate: AnyObject {
    func imagesCountChanged(_ count: Int)
}

final class ItemEditViewModel {
    // MARK: State
    enum State {
        case empty
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
    weak var delegate: ItemEditViewModelDelegate?
    private(set) var currencies: [String] = ["KRW", "JPY", "USD", "EUR", "CNY"]
    private(set) var images: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let imagesCount = self?.images.count else { return }
                self?.delegate?.imagesCountChanged(imagesCount)
            }
        }
    }
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
    private let useCase: ItemEditNetworkUseCaseProtocol
    private let imageNetworkUseCase = ImageNetworkUseCase()

    init(useCase: ItemEditNetworkUseCaseProtocol = ItemEditNetworkUseCase()) {
        self.useCase = useCase
    }

    // MARK: Instance Method
    func bind(_ handler: @escaping (State) -> Void) {
        handler(state)
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
        if let discountedPriceText = discountedPriceText,
           let discountedPrice = Int(discountedPriceText),
           let priceText = priceText,
           let price = Int(priceText) {
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
        let imageDatas = images.map { image in
            image.compress(target: 300)
        }
        guard let title = title, let stock = stock, let currency = currency, let price = price, let descriptions = descriptions else {
            return
        }
        let postItem = PostItem(title: title, descriptions: descriptions, price: price, currency: currency, stock: stock, discountedPrice: discountedPrice, images: imageDatas, password: password)
        useCase.request(path: OpenMarketAPI.postProduct.urlString, with: postItem, for: .post) { [weak self] result in
            switch result {
            case .success(let item):
                self?.state = .register(item)
            case .failure(let error):
                self?.state = .error(.editUseCaseError(error))
            }
        }
    }

    func loadItem(id: Int) {
        let path = OpenMarketAPI.loadProduct(id: id).urlString
        useCase.request(path: path, with: nil, for: .get) { [weak self] result in
            switch result {
            case .success(let item):
                self?.loadImages(item: item)
            case .failure(let error):
                self?.state = .error(.editUseCaseError(error))
            }
        }
    }

    private func loadImages(item: Item) {
        let dispatchGroup = DispatchGroup()
        guard let imagePaths = item.images else { return }
        for imagePath in imagePaths {
            dispatchGroup.enter()
            DispatchQueue(label: "ImageLoadQueue", attributes: .concurrent).async(group: dispatchGroup) { [weak self] in
                self?.imageNetworkUseCase.retrieveImage(with: imagePath) { result in
                    switch result {
                    case .success(let image):
                        self?.images.append(image)
                        dispatchGroup.leave()
                    case .failure(let error):
                        self?.state = .error(.imageUseCaseError(error))
                    }
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            self?.state = .initial(item)
        }
    }
}
