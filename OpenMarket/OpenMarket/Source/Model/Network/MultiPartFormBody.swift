//
//  MultiPartFormBody.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

protocol MultiPartFormProtocol {
    var boundary: String { get }
    func create<T: Multipartable>(with item: T) -> Data
}

final class MultiPartFormBody: MultiPartFormProtocol {
    var boundary: String = UUID().uuidString
    let multiPartGenerator: MultiPartProtocol

    init(multiPartGenerator: MultiPartProtocol) {
        self.multiPartGenerator = multiPartGenerator
    }

    func create<T>(with item: T) -> Data where T: Multipartable {
        var data: Data = Data()
        for (key, value) in item.dictionary {
            guard let value = value else { continue }
            if let value = value as? [Data] {
                data.append(multiPartGenerator.multiPart(boundary: boundary, name: key, contentType: .imageJpeg, datas: value))
            } else {
                data.append(multiPartGenerator.multiPart(boundary: boundary, name: key, fileName: nil, contentType: nil, value: value))
            }
        }
        data.appendString(MultiPartFormat.endBoundary(boundary))
        return data
    }
}
