//
//  Dummy.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/03.
//

import Foundation
@testable import OpenMarket

enum Dummy {
    static let postItem: PostItem = .init(title: "iPhone", descriptions: "애플폰", price: 1000000,
                                          currency: "KRW", stock: 9, discountedPrice: 900000,
                                          images: [Data()], password: "password")
    static let patchItem: PatchItem = .init(title: "iMac", descriptions: "컴퓨터", price: 2000000,
                                            currency: "KRW", stock: 10, discountedPrice: 1000000,
                                            images: [Data()], password: "password")
    static let deleteItem: DeleteItem = .init(password: "password")
    static var itemDetail: ItemDetail = .init(id: 10, title: "MacBookPro", descriptions: "노트북",
                                              price: 123, currency: "KRw", stock: 33, discountedPrice: nil,
                                              thumbnails: ["www.kane.com"], images: ["www.kane.com"], registrationDate: 3.0)
}
