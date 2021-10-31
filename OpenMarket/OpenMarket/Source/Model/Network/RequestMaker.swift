//
//  RequestMaker.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

protocol RequestMakable {
    func request(url: URL, httpMethod: HttpMethod, with item: Any) -> URLRequest?
}

struct RequestMaker: RequestMakable {
    private enum Format {
        static let contentType = "Content-Type"
        static func multiPartContentType(_ boundary: String) -> String {
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
    private let multiPartForm: MultiPartFormProtocol

    init(multiPartForm: MultiPartFormProtocol = MultiPartForm()) {
        self.multiPartForm = multiPartForm
    }

    func request(url: URL, httpMethod: HttpMethod, with item: Any) -> URLRequest? {
        if let item = item as? PostItem {
            return multiPartRequest(url: url, httpMethod: httpMethod, with: item)
        } else if let item = item as? PatchItem {
            return multiPartRequest(url: url, httpMethod: httpMethod, with: item)
        } else if let item = item as? DeleteItem {
            return jsonRequest(url: url, httpMethod: httpMethod, with: item)
        }
        return nil
    }

    private func jsonRequest<T: Encodable>(url: URL, httpMethod: HttpMethod, with item: T) -> URLRequest? {
        guard let data = try? JSONEncoder().encode(item) else {
            return nil
        }
        var request: URLRequest = URLRequest(url: url)
        request.setValue(MimeType.applicationJson.description, forHTTPHeaderField: Format.contentType)
        request.httpMethod = httpMethod.description
        request.httpBody = data
        return request
    }

    private func multiPartRequest<T: Multipartable>(url: URL, httpMethod: HttpMethod, with item: T) -> URLRequest {
        let boundary = UUID().uuidString
        var request: URLRequest = URLRequest(url: url)
        request.setValue(Format.multiPartContentType(boundary), forHTTPHeaderField: Format.contentType)
        request.httpMethod = httpMethod.description
        request.httpBody = multiPartForm.create(with: item, boundary: boundary)
        return request
    }
}
