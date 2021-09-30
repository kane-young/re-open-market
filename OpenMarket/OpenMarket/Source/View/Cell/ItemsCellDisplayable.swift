//
//  ItemsCellDisplayable.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/30.
//

import UIKit

protocol ItemsCellDisplayable: UICollectionViewCell {
    func bind(_ viewModel: ItemListCellViewModel)
    func fire()
}
