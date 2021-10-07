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
}
