//
//  ThumbnailUseCase.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

final class ImageNetworkUseCase: ImageNetworkUseCaseProtocol {
    static let shared: ImageNetworkUseCase = .init()

    private let networkManager: NetworkManagable
    private let cache: NSCache = NSCache<NSURL, UIImage>()

    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    @discardableResult
    func retrieveImage(with urlString: String, completionHandler: @escaping (Result<UIImage, ImageNetworkUseCaseError>) -> Void) -> URLSessionDataTask? {
        guard let keyForCaching = NSURL(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        if let cachedImaged = cache.object(forKey: keyForCaching) {
            completionHandler(.success(cachedImaged))
            return nil
        }
        let task = networkManager.request(urlString: urlString, with: nil, httpMethod: .get) { [weak self] result in
            let result = result.flatMapError { .failure(ImageNetworkUseCaseError.networkError($0)) }
                .flatMap { data -> Result<UIImage, ImageNetworkUseCaseError> in
                    guard let image = UIImage(data: data) else {
                        return .failure(ImageNetworkUseCaseError.convertDataToImageError)
                    }
                    self?.cache.setObject(image, forKey: keyForCaching)
                    return .success(image)
                }
            completionHandler(result)
        }
        return task
    }
}
