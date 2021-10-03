//
//  ItemGridCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/29.
//

import UIKit

final class ItemGridCollectionViewCell: UICollectionViewCell, ItemCellDisplayable {
    static let identifier: String = "ItemGridCell"

    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .systemRed
        return label
    }()
    private var discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    private lazy var priceLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, discountedPriceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Style.StackView.defaultSpacing
        return stackView
    }()

    private var viewModel: ItemListCellViewModel?

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        stockLabel.text = nil
        discountedPriceLabel.text = nil
    }

    func bind(_ viewModel: ItemListCellViewModel) {
        self.viewModel = viewModel
        viewModel.bind { [weak self] state in
            switch state {
            case .update(let metaData):
                self?.thumbnailImageView.image = metaData.thumbnail
                self?.titleLabel.text = metaData.title
                self?.priceLabel.text = metaData.originalPrice
                self?.stockLabel.text = metaData.stock
                self?.stockLabel.textColor = metaData.stockLabelTextColor
                self?.discountedPriceLabel.isHidden = metaData.isneededDiscountedLabel
                self?.discountedPriceLabel.attributedText = metaData.discountedPrice
            case .error(_):
                self?.thumbnailImageView.image = nil
            default:
                break
            }
        }
    }

    func fire() {
        viewModel?.configureCell()
    }

    private func configureViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(priceLabelsStackView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stockLabel)
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = Style.borderWidth
        layer.cornerRadius = Style.cornerRadius
        contentView.backgroundColor = .systemBackground
    }

    private func configureConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let contentView = self.contentView
        NSLayoutConstraint.activate([
            thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                       multiplier: Style.ImageView.sizeRatio),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            thumbnailImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                    constant: Style.Views.defaultMargin),
            thumbnailImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                       constant: -Style.Views.defaultMargin),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                constant: Style.Views.defaultMargin),
            priceLabelsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            priceLabelsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                      constant: Style.Views.defaultMargin),
            priceLabelsStackView.bottomAnchor.constraint(equalTo: stockLabel.topAnchor,
                                                         constant: -Style.Views.defaultMargin),
            priceLabelsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                          constant: Style.Views.defaultMargin),
            stockLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                constant: Style.Views.defaultMargin),
            stockLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                               constant: -Style.Views.defaultMargin),
            stockLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

extension ItemGridCollectionViewCell {
    enum Style {
        static let borderWidth: CGFloat = 1.0
        static let cornerRadius: CGFloat = 15
        enum StackView {
            static let defaultSpacing: CGFloat = 5
        }
        enum Views {
            static let defaultMargin: CGFloat = 10
        }
        enum ImageView {
            static let sizeRatio: CGFloat = 0.5
        }
    }
}
