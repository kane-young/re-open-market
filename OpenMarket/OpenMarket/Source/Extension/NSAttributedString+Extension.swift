//
//  NSAttributedString+Extension.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: attributeString.length)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        return attributeString
    }
}
