//
//  ThumbnailUseCase.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

class ThumbnailUseCase: ThumbnailUseCaseProtocol {
    private let networkManager: NetworkManagable
    static var cache: NSCache = NSCache<NSURL, UIImage>()

    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func retrieveImage(with urlString: String, completionHandler: @escaping (Result<UIImage, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask? {
        guard let keyForCaching = NSURL(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        if let cachedImaged = ThumbnailUseCase.cache.object(forKey: keyForCaching) {
            completionHandler(.success(cachedImaged))
            return nil
        }
        let task = networkManager.fetch(with: urlString) { result in
            let result = result.flatMapError { .failure(ThumbnailUseCaseError.networkError($0)) }
                .flatMap { data -> Result<UIImage, ThumbnailUseCaseError> in
                    guard let image = UIImage(data: data) else {
                        return .failure(ThumbnailUseCaseError.convertDataToImageError)
                    }
                    ThumbnailUseCase.cache.setObject(image, forKey: keyForCaching)
                    return .success(image)
                }
            completionHandler(result)
        }
        return task
    }
}
