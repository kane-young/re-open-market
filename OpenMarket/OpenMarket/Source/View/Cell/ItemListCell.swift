//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

class ItemListCell: UICollectionViewCell, ItemCellDisplayable {
    static let identifier: String = "ItemListCell"

    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemRed
        return label
    }()
    private var discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    private lazy var priceLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, discountedPriceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = Style.StackView.defaultSpacing
        return stackView
    }()
    private lazy var itemInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, priceLabelsStackView])
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(itemInfoStackView)
        contentView.backgroundColor = Style.backgroundColor
    }

    private func configureConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                        constant: Style.Views.defaultMargin),
            thumbnailImageView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                    constant: Style.Views.defaultMargin),
            thumbnailImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                       constant: -Style.Views.defaultMargin),
            thumbnailImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor,
                                                         constant: -Style.Views.defaultMargin),
            itemInfoStackView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            itemInfoStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor,
                                                       constant: Style.Views.defaultMargin),
            itemInfoStackView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            itemInfoStackView.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor,
                                                        constant: -Style.Views.defaultMargin),
            stockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                 constant: -Style.Views.defaultMargin),
            stockLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor)
        ])
        stockLabel.setContentHuggingPriority(Style.Priority.veryHigh, for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(Style.Priority.veryHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

extension ItemListCell {
    private enum Style {
        static let backgroundColor = UIColor.white
        enum StackView {
            static let defaultSpacing: CGFloat = 5
        }
        enum Views {
            static let defaultMargin: CGFloat = 10
        }
        enum Priority {
            static let veryHigh: UILayoutPriority = UILayoutPriority(1000)
        }
    }
}
