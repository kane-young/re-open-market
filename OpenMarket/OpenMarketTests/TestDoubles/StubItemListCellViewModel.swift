//
//  StubItemListCellViewModel.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

@testable import OpenMarket
import UIKit

final class StubSuccessThumbnailUseCase: ImageNetworkUseCaseProtocol {
    func retrieveImage(with urlString: String, completionHandler: @escaping (Result<UIImage, ImageNetworkUseCaseError>) -> Void) -> URLSessionDataTask? {
        completionHandler(.success(UIImage(named: "OpenMarket")!))
        return nil
    }
}

final class StubFailureThumbnailUseCase: ImageNetworkUseCaseProtocol {
    func retrieveImage(with urlString: String, completionHandler: @escaping (Result<UIImage, ImageNetworkUseCaseError>) -> Void) -> URLSessionDataTask? {
        completionHandler(.failure(.networkError(.invalidRequest)))
        return nil
    }
}
