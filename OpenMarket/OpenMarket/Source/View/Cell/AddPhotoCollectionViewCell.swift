//
//  AddPhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/10.
//

import UIKit

final class AddPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "AddPhotoCollectionViewCell"

    // MARK: View Properties
    private let imageView: UIImageView = {
        let imageView: UIImageView = .init(image: Style.ImageView.addButtonImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Style.defaultTintColor
        return imageView
    }()
    private let photoCountLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Style.defaultTextColor
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "\(Int.zero)/\(Style.maximumPhotoCount)"
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [imageView, photoCountLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Style.Views.defaultMargin
        return stackView
    }()

    private var photoCount: Int = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellStyle()
        addSubviews()
        configureConstraints()
        configureNotification()
    }

    deinit {
        removeNotification()
    }

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    private func configureCellStyle() {
        contentView.layer.borderWidth = Style.Views.borderWidth
        contentView.layer.borderColor = Style.Views.borderColor
        contentView.layer.cornerRadius = Style.Views.cornerRadius
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

    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotosCount(_:)),
                                               name: NSNotification.Name(rawValue: Style.Notification.addPhoto), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deletePhotosCount(_:)),
                                               name: NSNotification.Name(rawValue: Style.Notification.deletePhoto), object: nil)
    }

    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Style.Notification.addPhoto),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Style.Notification.deletePhoto),
                                                  object: nil)
    }

    @objc private func addPhotosCount(_ notification: Notification) {
        photoCount += 1
        photoCountLabel.text = "\(photoCount)/\(Style.maximumPhotoCount)"
    }

    @objc private func deletePhotosCount(_ notification: Notification) {
        photoCount -= 1
        photoCountLabel.text = "\(photoCount)/\(Style.maximumPhotoCount)"
    }
}

extension AddPhotoCollectionViewCell {
    // MARK: Style
    enum Style {
        static let defaultTintColor: UIColor = .label
        static let defaultTextColor: UIColor = .label
        static let maximumPhotoCount: Int = 5
        enum ImageView {
            static let addButtonImage: UIImage? = .init(systemName: "camera")
        }
        enum Views {
            static let defaultMargin: CGFloat = 5
            static let borderWidth: CGFloat = 1
            static let borderColor: CGColor = UIColor.lightGray.cgColor
            static let cornerRadius: CGFloat = 15
        }
        enum Notification {
            static let addPhoto = "addPhoto"
            static let deletePhoto = "deletePhoto"
        }
    }
}
