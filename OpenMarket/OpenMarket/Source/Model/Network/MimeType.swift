//
//  MimeType.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/24.
//

import Foundation

enum MimeType {
    case applicationJson
    case imageJpeg

    var fileExtension: String {
        switch self {
        case .applicationJson:
            return ".json"
        case .imageJpeg:
            return ".jpeg"
        }
    }
}

extension MimeType: CustomStringConvertible {
    var description: String {
        switch self {
        case .applicationJson:
            return "application/json"
        case .imageJpeg:
            return "image/jpeg"
        }
    }
}
