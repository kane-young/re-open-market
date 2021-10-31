//
//  MultipartFormProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/23.
//

import Foundation

protocol MultiPartFormProtocol {
    func create(with item: Multipartable, boundary: String) -> Data
}

struct MultiPartForm: MultiPartFormProtocol {
    private enum Format {
        static let contentDisposition = "Content-Disposition: "
        static let contentType = "Content-Type: "
        static let formData = "form-data"
        static let crlf = "\r\n"

        static func name(_ string: String) -> String {
            return "; name=\"\(string)\""
        }
        static func fileName(_ string: String) -> String {
            return "; filename=\"\(string)\""
        }
        static func starting(_ boundary: String) -> String {
            return "--\(boundary)\(crlf)"
        }
        static func ending(_ boundary: String) -> String {
            return "--\(boundary)--\r\n"
        }
    }

    func create(with item: Multipartable, boundary: String) -> Data {
        var data: Data = Data()
        for (key, value) in item.dictionary {
            guard let value = value else { continue }
            if let value = value as? [Data] {
                data.append(multiPart(boundary: boundary, name: key, contentType: .imageJpeg, datas: value))
            } else {
                data.append(multiPart(boundary: boundary, name: key, fileName: nil, contentType: nil, value: value))
            }
        }
        data.appendString(Format.ending(boundary))
        return data
    }

    private func multiPart(boundary: String, name: String, contentType: MimeType, datas: [Data]) -> Data {
        var body: Data = Data()
        var index: Int = 0
        for data in datas {
            body.appendString(Format.starting(boundary))
            let fileName = "\(index)\(contentType.fileExtension)"
            index += 1
            body.append(contentHeader(name: name + "[]", fileName: fileName, contentType: contentType))
            body.append(data)
            body.appendString(Format.crlf)
        }
        return body
    }

    private func multiPart(boundary: String, name: String, fileName: String? = nil, contentType: MimeType? = nil, value: Any) -> Data {
        var data = Data()
        data.appendString(Format.starting(boundary))
        if let value = value as? [Any] {
            data.append(contentHeader(name: name + "[]", fileName: fileName, contentType: contentType))
            data.appendString("\(value)" + Format.crlf)
        } else {
            data.append(contentHeader(name: name, fileName: fileName, contentType: contentType))
            data.appendString("\(value)" + Format.crlf)
        }
        return data
    }

    private func contentHeader(name: String,
                               fileName: String? = nil,
                               contentType: MimeType? = nil) -> Data {
        var header = Format.contentDisposition + Format.formData + Format.name(name)
        if let fileName = fileName {
            header += Format.fileName(fileName) + Format.crlf
        } else {
            header += Format.crlf + Format.crlf
        }
        if let mimeType = contentType {
            header += Format.contentType + "\(mimeType)" + Format.crlf + Format.crlf
        }
        return Data(header.utf8)
    }
}
