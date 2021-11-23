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

    func retrieveImage(with urlString: String, completionHandler: @escaping (Result<UIImage, ImageNetworkUseCaseError>) -> Void) {
        guard let keyForCaching = NSURL(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        if let cachedImaged = cache.object(forKey: keyForCaching) {
            completionHandler(.success(cachedImaged))
            return
        }
        networkManager.request(urlString: urlString, with: nil, httpMethod: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completionHandler(.failure(.convertDataToImageError))
                    return
                }
                self.cache.setObject(image, forKey: keyForCaching)
                completionHandler(.success(image))
            case .failure(let error):
                completionHandler(.failure(.networkError(error)))
            }
        }
    }
}
