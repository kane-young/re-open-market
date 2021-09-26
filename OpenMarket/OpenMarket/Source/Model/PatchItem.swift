//
//  PatchItem.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/23.
//

import Foundation

struct PatchItem: Multipartable {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String

    var dictionary: [String: Any?] {
        [
            "title": self.title,
             "descriptions": self.descriptions,
             "price": self.price,
             "currency": self.currency,
             "stock": self.stock,
             "discountedPrice": self.discountedPrice,
             "images": self.images,
             "password": self.password
        ]
    }
}
