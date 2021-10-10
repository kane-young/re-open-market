//
//  AddPhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import UIKit

class AddPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "AddPhotoCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "camera"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        return imageView
    }()
    private let photoCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "1/5"
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, photoCountLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellStyle()
        addSubviews()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    private func configureCellStyle() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 15
    }

    private func addSubviews() {
        contentView.addSubview(stackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
