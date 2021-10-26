//
//  Dummy.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/03.
//

import UIKit
@testable import OpenMarket

enum Dummy {
    static let titleText: String = "iPhone13 mini"
    static let stockText: String = "300"
    static let currencyText: String = "KRW"
    static let priceText: String = "30000"
    static let discountedPriceText: String = "15000"
    static let descriptionsText: String = "아이폰 13 미니 신제품입니다"
    static let id: Int = 50
    static let password: String = "password"
    static let image: UIImage? = UIImage(named: "OpenMarket")
    static let postItem: PostItem = .init(title: "iPhone", descriptions: "애플폰", price: 1000000,
                                          currency: "KRW", stock: 9, discountedPrice: 900000,
                                          images: [Data()], password: "password")
    static let patchItem: PatchItem = .init(title: "iMac", descriptions: "컴퓨터", price: 2000000,
                                            currency: "KRW", stock: 10, discountedPrice: 1000000,
                                            images: [Data()], password: "password")
    static let deleteItem: DeleteItem = .init(password: "password")
    static var itemDetail: Item = .init(id: 10, title: "MacBookPro", descriptions: "노트북", price: 123,
                                        currency: "KRw", stock: 33, discountedPrice: nil,
                                        thumbnails: ["www.kane.com"], images: ["www.kane.com"], registrationDate: 3.0)
    static let items = [Item(id: 1, title: "12", descriptions: nil, price: 33, currency: "KRW", stock: 12,
                             discountedPrice: nil, thumbnails: ["naver.com"], images: nil, registrationDate: 33123)]
    static let normalItem = Item(id: 1, title: "12", descriptions: nil, price: 33, currency: "KRW", stock: 12,
                                 discountedPrice: nil, thumbnails: ["naver.com"], images: nil, registrationDate: 33123)
    static let outOfStockItem = Item(id: 1, title: "iPad", descriptions: nil, price: 100000, currency: "KRW",
                                     stock: 0, discountedPrice: nil, thumbnails: ["www.kane.com"], images: nil,
                                     registrationDate: 3.0)
    static let quantitiousItem = Item(id: 1, title: "iPad", descriptions: nil, price: 100000, currency: "KRW",
                                      stock: 1000, discountedPrice: nil, thumbnails: ["www.kane.com"], images: nil,
                                      registrationDate: 3.0)
    static let emptyThumbnailItem = Item(id: 1, title: "iPad", descriptions: nil, price: 100000, currency: "KRW",
                                         stock: 1000, discountedPrice: nil, thumbnails: [], images: nil,
                                         registrationDate: 3.0)
    static let thumbnailUrlString = "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png"
}
