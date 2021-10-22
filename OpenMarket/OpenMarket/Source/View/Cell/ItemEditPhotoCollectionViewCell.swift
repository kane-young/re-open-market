//
//  ItemPhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import UIKit

final class ItemEditPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ItemPhotoCollectionViewCell"

    // MARK: View Properties
    private let imageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Style.defaultCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    let deleteButton: UIButton = {
        let button: UIButton = .init()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(Style.DeleteButton.image, for: .normal)
        button.layer.cornerRadius = button.bounds.width / 2
        button.tintColor = .black
        button.backgroundColor = .none
        button.clipsToBounds = true
        return button
    }()

    // MARK: Property
    private var viewModel: PhotoCellViewModel?

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

    // MARK: Instance Method
    func addDeleteButtonTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        deleteButton.addTarget(target, action: action, for: event)
    }

    func bind(_ viewModel: PhotoCellViewModel) {
        self.viewModel = viewModel
        viewModel.bind { [weak self] state in
            switch state {
            case .update(let image):
                self?.imageView.image = image
            default:
                break
            }
        }
    }

    func configureCell() {
        viewModel?.configureCell()
    }

    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
    }

    private func configureConstraints() {
        deleteButton.imageView?.layoutMargins = .zero
        deleteButton.layoutMargins = .zero
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.centerXAnchor.constraint(equalTo: contentView.leadingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            deleteButton.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                multiplier: Style.DeleteButton.sizeRatio)
        ])
    }

    private func configureCellStyle() {
        contentView.layer.cornerRadius = Style.defaultCornerRadius
        contentView.layer.borderWidth = Style.defaultBorderWidth
        contentView.layer.borderColor = Style.ContentView.borderColor
    }
}

extension ItemEditPhotoCollectionViewCell {
    // MARK: Style
    enum Style {
        static let defaultCornerRadius: CGFloat = 15
        static let defaultBorderWidth: CGFloat = 1
        enum ContentView {
            static let borderColor: CGColor = UIColor.lightGray.cgColor
        }
        enum DeleteButton {
            static let image: UIImage? = .init(systemName: "xmark.circle")
            static let backgroundColor: UIColor = .systemBackground
            static let tintColor: UIColor = .label
            static let sizeRatio: CGFloat = 1/4
            static let borderColor: CGColor = UIColor.systemBackground.cgColor
        }
    }
}
