//
//  StubItemListCellViewModel.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

@testable import OpenMarket
import UIKit

final class StubSuccessImageNetworkUseCase: ImageNetworkUseCaseProtocol {
    func retrieveImage(with urlString: String, completionHandler: @escaping (Result<UIImage, ImageNetworkUseCaseError>) -> Void) {
        completionHandler(.success(UIImage(named: "OpenMarket")!))
        return
    }
}

final class StubFailureImageNetworkUseCase: ImageNetworkUseCaseProtocol {
    func retrieveImage(with urlString: String, completionHandler: @escaping (Result<UIImage, ImageNetworkUseCaseError>) -> Void) {
        completionHandler(.failure(.networkError(.invalidRequest)))
        return
    }
}
