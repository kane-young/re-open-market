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

    private var urlPath: String {
        switch self {
        case .load(let page):
            return "/items/\(page)"
        case .loadProduct(let id):
            return "/item/\(id)"
        case .postProduct:
            return "/item/"
        case .patchProduct(let id):
            return "/item/\(id)"
        case .deleteProduct(let id):
            return "/item/\(id)"
        }
    }

    var url: URL? {
        let baseURL: String = "https://camp-open-market-2.herokuapp.com"
        return URL(string: "\(baseURL)\(urlPath)")
    }

    var httpMethod: HttpMethod {
        switch self {
        case .load:
            return .get
        case .loadProduct:
            return .get
        case .postProduct:
            return .post
        case .patchProduct:
            return .patch
        case .deleteProduct:
            return .delete
        }
    }
}
