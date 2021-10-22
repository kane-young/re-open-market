//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/12.
//

import UIKit

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let screenScale = UIScreen.main.scale
        let canvas = CGSize(width: size.width * percentage * screenScale, height: size.height * percentage * screenScale)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: canvas).integral)
        }
    }

    func compress(target kiloByte: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kiloByte * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var iscompleted = false
        while !iscompleted {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    iscompleted = true
                    return data
                } else {
                    let multiplier: CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}
