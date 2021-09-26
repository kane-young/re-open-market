//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

enum NetworkError: Error {
    case connectionProblem
    case invalidResponseStatuscode
    case invalidData
    case invalidURL
    case invalidRequest
    case encodingError
}
