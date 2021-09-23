//
//  ItemList.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/23.
//

import Foundation

struct ItemList: Decodable {
    let page: Int
    let items: [Item]

    struct Item: Decodable {
        let id: Int
        let title: String
        let price: Int
        let currency: String
        let stock: Int
        let discountedPrice: Int?
        let thumbnails: [String]
        let registrationDate: Double

        private enum CodingKeys: String, CodingKey {
            case id, title, price, currency, stock, thumbnails
            case discountedPrice = "discounted_price"
            case registrationDate = "registration_date"
        }
    }
}
