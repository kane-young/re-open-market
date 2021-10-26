//
//  ImageNetworkUseCaseProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import UIKit

protocol ImageNetworkUseCaseProtocol {
    @discardableResult
    func retrieveImage(with urlString: String,
                       completionHandler: @escaping (Result<UIImage, ImageNetworkUseCaseError>) -> Void) -> URLSessionDataTask?
}
