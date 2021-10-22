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

protocol ItemEditNetworkUseCaseProtocol {
    func request(path urlString: String, with item: Multipartable, for httpMethod: HttpMethod,
                 completionHandler: @escaping (Result<Item, ItemEditUseCaseError>) -> Void)
}

enum ItemEditUseCaseError: Error {
    case decodingError
    case networkError(NetworkError)
}

final class ItemEditNetworkUseCase: ItemEditNetworkUseCaseProtocol {
    private let networkManager: NetworkManagable
    private let decoder: JSONDecoder = .init()

    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func request(path urlString: String, with item: Multipartable, for httpMethod: HttpMethod, completionHandler: @escaping (Result<Item, ItemEditUseCaseError>) -> Void) {
        networkManager.request(urlString: urlString, with: item, httpMethod: httpMethod) { [weak self] result in
            switch result {
            case .success(let data):
                guard let item = try? self?.decoder.decode(Item.self, from: data) else {
                    completionHandler(.failure(.decodingError))
                    return
                }
                completionHandler(.success(item))
            case .failure(let error):
                completionHandler(.failure(.networkError(error)))
            }
        }
    }
}

enum ItemEditViewModelError: Error {
    case useCaseError(ItemEditUseCaseError)
}

final class ItemEditViewModel {
    weak var delegate: ItemEditViewModelDelegate?
    private(set) var currencies: [String] = ["KRW", "JPY", "USD", "EUR", "CNY"]
    private(set) var images: [UIImage] = [] {
        didSet {
            delegate?.imagesCountChanged(images.count)
        }
    }
    private var title: String?
    private var stock: Int?
    private var currency: String?
    private var price: Int?
    private var discountedPrice: Int?
    private var descriptions: String?
    private var password: String?
    private var state: ItemEditViewModelState = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else {
                    return
                }
                self?.handler?(state)
            }
        }
    }
    private var handler: ((ItemEditViewModelState) -> Void)?
    private let useCase: ItemEditNetworkUseCaseProtocol

    init(useCase: ItemEditNetworkUseCaseProtocol = ItemEditNetworkUseCase()) {
        self.useCase = useCase
    }

    func bind(_ handler: @escaping (ItemEditViewModelState) -> Void) {
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

    func validate(title: String?, stock: String?, currency: String?, price: String?,
                  discountedPrice: String?,descriptions: String?) {
        if let discountedPrice = discountedPrice {
            self.discountedPrice = Int(discountedPrice)
        }
        if !images.isEmpty, let title = title, let stock = stock, let currency = currency, let price = price,
           let descriptions = descriptions, descriptions != ItemEditViewController.Style.DescriptionsTextView.placeHolder {
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
                self?.state = .error(.useCaseError(error))
            }
        }
    }
}
