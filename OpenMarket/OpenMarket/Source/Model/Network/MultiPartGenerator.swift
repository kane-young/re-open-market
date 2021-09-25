//
//  MultipartFormProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/23.
//

import Foundation

protocol MultiPartProtocol {
    func multiPart(boundary: String, name: String, contentType: MimeType, datas: [Data]) -> Data
    func multiPart(boundary: String, name: String, fileName: String?, contentType: MimeType?, value: Any) -> Data
}

final class MultiPartGenerator: MultiPartProtocol {
    func multiPart(boundary: String,
                   name: String,
                   contentType: MimeType,
                   datas: [Data]) -> Data {
        var body: Data = Data()
        var index: Int = 0
        for data in datas {
            body.appendString(MultiPartFormat.startBoundary(boundary))
            let fileName = "image\(index)\(contentType.fileExtension)"
            index += 1
            body.append(contentHeader(name: name + "[]", fileName: fileName, contentType: contentType))
            body.append(data)
            body.appendString(MultiPartFormat.crlf)
        }
        return body
    }

    func multiPart(boundary: String,
                   name: String,
                   fileName: String? = nil,
                   contentType: MimeType? = nil,
                   value: Any) -> Data {
        var data = Data()
        data.appendString(MultiPartFormat.startBoundary(boundary))
        if let value = value as? [Any] {
            data.append(contentHeader(name: name + "[]", fileName: fileName, contentType: contentType))
            data.appendString("\(value)" + MultiPartFormat.crlf)
        } else {
            data.append(contentHeader(name: name, fileName: fileName, contentType: contentType))
            data.appendString("\(value)" + MultiPartFormat.crlf)
        }
        return data
    }

    private func contentHeader(name: String,
                               fileName: String? = nil,
                               contentType: MimeType? = nil) -> Data {
        var header = MultiPartFormat.contentDisposition + MultiPartFormat.formData + MultiPartFormat.name(name)
        if let fileName = fileName {
            header += MultiPartFormat.fileName(fileName)
        }
        header += MultiPartFormat.crlf
        if let contentType = contentType {
            header += MultiPartFormat.contentType + "\(contentType)" + MultiPartFormat.crlf
        }
        header += MultiPartFormat.crlf
        return Data(header.utf8)
    }
}
