//
//  ItemPhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import UIKit

final class ItemPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ItemPhotoCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let deleteButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureConstraints()
        configureCellStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func addDeleteButtonTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        deleteButton.addTarget(target, action: action, for: event)
    }

    private func addSubviews() {
        contentView.addSubview(imageView)
        imageView.addSubview(deleteButton)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ])
    }

    private func configureCellStyle() {
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.label.cgColor
    }
}
