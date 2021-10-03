//
//  OpenMarket.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

enum OpenMarketAPI {
    static let successStatusCode: ClosedRange<Int> = (200...299)

    case load(page: Int)
    case loadProduct(id: Int)
    case postProduct
    case patchProduct(id: Int)
    case deleteProduct(id: Int)

    var urlString: String {
        let baseURL: String = "https://camp-open-market-2.herokuapp.com"
        switch self {
        case .load(let page):
            return "\(baseURL)/items/\(page)"
        case .loadProduct(let id):
            return "\(baseURL)/item/\(id)"
        case .postProduct:
            return "\(baseURL)/item/"
        case .patchProduct(let id):
            return "\(baseURL)/item/\(id)"
        case .deleteProduct(let id):
            return "\(baseURL)/item/\(id)"
        }
    }

    var path: URL? {
        return URL(string: self.urlString)
    }
}
