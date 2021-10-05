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
    static let items = [ItemList.Item(id: 1, title: "12", price: 33, currency: "KRW", stock: 12,
                                      discountedPrice: nil, thumbnails: ["naver.com"],
                                      registrationDate: 33123)]
    static let normalItem = ItemList.Item(id: 1, title: "12", price: 33, currency: "KRW", stock: 12,
                                          discountedPrice: nil, thumbnails: ["naver.com"],
                                          registrationDate: 33123)
    static let outOfStockItem = ItemList.Item(id: 1, title: "iPad", price: 100000, currency: "KRW",
                                          stock: 0, discountedPrice: nil, thumbnails: ["www.kane.com"],
                                          registrationDate: 3.0)
    static let quantitiousItem = ItemList.Item(id: 1, title: "iPad", price: 100000, currency: "KRW",
                                           stock: 1000, discountedPrice: nil, thumbnails: ["www.kane.com"],
                                           registrationDate: 3.0)
    static let emptyThumbnailItem = ItemList.Item(id: 1, title: "iPad", price: 100000, currency: "KRW",
                                              stock: 1000, discountedPrice: nil, thumbnails: [],
                                              registrationDate: 3.0)
    static let thumbnailUrlString = "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png"
}
