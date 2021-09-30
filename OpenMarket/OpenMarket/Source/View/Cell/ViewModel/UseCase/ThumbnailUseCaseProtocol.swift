//
//  ThumbnailUseCaseType.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import UIKit

protocol ThumbnailUseCaseProtocol {
    func retrieveImage(with urlString: String,
                       completionHandler: @escaping (Result<UIImage, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask?
}
