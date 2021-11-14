//
//  ItemDetailCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/13.
//

import UIKit

final class ItemDetailPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ItemDetailCollectionViewCell"

    // MARK: View Property
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    // MARK: Instance Method
    func configureCell(with image: UIImage) {
        imageView.image = image
    }

    private func addSubviews() {
        contentView.addSubview(imageView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: imageView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}
