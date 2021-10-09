//
//  BorderView.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/09.
//

import UIKit

class BorderView: UIView {
    init() {
        
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    private func configureView() {
        backgroundColor = .systemGray2
        
    }
}
