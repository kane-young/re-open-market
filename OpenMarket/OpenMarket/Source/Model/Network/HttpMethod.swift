//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case patch
    case delete
}

extension HttpMethod: CustomStringConvertible {
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
