//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

enum NetworkError: Error {
    case connectionProblem
    case invalidResponseStatuscode(Int)
    case invalidData
    case invalidURL
    case invalidRequest

    var message: String {
        switch self {
        case .connectionProblem:
            return "dataTask작업 error 존재"
        case .invalidResponseStatuscode(let code):
            return "Response StatusCode \(code)"
        case .invalidData:
            return "dataTask작업 Data 미반환"
        case .invalidURL:
            return "유효하지 않는 URL"
        case .invalidRequest:
            return "유효하지 않는 Request"
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
