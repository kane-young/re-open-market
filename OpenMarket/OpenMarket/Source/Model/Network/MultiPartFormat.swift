//
//  MultiPartFormat.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

enum MultiPartFormat {
    static let crlf = "\r\n"
    static let contentDisposition = "Content-Disposition: "
    static let contentType = "Content-Type: "
    static let formData = "form-data"
    
    static func name(_ string: String) -> String {
        return "; name=\"\(string)\""
    }
    static func fileName(_ string: String) -> String {
        return "; fileName=\"\(string)\""
    }
    static func startBoundary(_ boundary: String) -> String {
        return "--\(boundary)\(crlf)"
    }
    static func endBoundary(_ boundary: String) -> String {
        return "--\(boundary)--\(crlf)"
    }
}
