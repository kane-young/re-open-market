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

    // MARk: Property
    private var viewModel: PhotoCellViewModel?

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
        viewModel = PhotoCellViewModel(image: image)
        viewModel?.bind({ [weak self] state in
            switch state {
            case .update(let image):
                self?.imageView.image = image
            default:
                break
            }
        })
        viewModel?.configureCell()
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
