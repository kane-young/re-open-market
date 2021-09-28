//
//  ThumbnailUseCase.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

protocol ThumbnailUseCaseType {
    func retrieveImage(with url: URL, completionHandler: @escaping (Result<UIImage, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask?
}

enum ThumbnailUseCaseError: Error {
    case networkError(NetworkError)
    case convertDataToImageError
}

class ThumbnailUseCase: ThumbnailUseCaseType {
    private let networkManager: NetworkManagable

    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func retrieveImage(with url: URL, completionHandler: @escaping (Result<UIImage, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask? {
        let task = networkManager.fetch(url: url) { result in
            let result = result.flatMapError { .failure(ThumbnailUseCaseError.networkError($0)) }
                .flatMap { data -> Result<UIImage, ThumbnailUseCaseError> in
                    guard let image = UIImage(data: data) else {
                        return .failure(ThumbnailUseCaseError.convertDataToImageError)
                    }
                    return .success(image)
                }
            completionHandler(result)
        }
        return task
    }
}
