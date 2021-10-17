//
//  ItemGridCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/29.
//

import UIKit

final class ItemGridCollectionViewCell: UICollectionViewCell, ItemCellDisplayable {
    static let identifier: String = "ItemGridCell"

    // MARK: View Properties
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = Style.stressedFont
        return label
    }()
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Style.defaultFont
        label.textAlignment = .center
        return label
    }()
    private var discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Style.defaultFont
        label.textAlignment = .center
        return label
    }()
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Style.defaultFont
        label.textAlignment = .center
        return label
    }()
    private lazy var priceLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, discountedPriceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Style.StackView.spacing
        return stackView
    }()

    // MARK: Property
    private var viewModel: ItemListCellViewModel?

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        configureView()
        configureConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        discountedPriceLabel.text = nil
        thumbnailImageView.image = nil
        priceLabel.attributedText = nil
        titleLabel.text = nil
        stockLabel.text = nil
    }

    // MARK: Instance Method
    func bind(_ viewModel: ItemListCellViewModel) {
        self.viewModel = viewModel
        viewModel.bind { [weak self] state in
            switch state {
            case .update(let metaData):
                self?.discountedPriceLabel.isHidden = metaData.isneededDiscountedLabel
                self?.discountedPriceLabel.text = metaData.discountedPrice
                self?.thumbnailImageView.image = metaData.thumbnail
                self?.priceLabel.attributedText = metaData.originalPrice
                self?.priceLabel.textColor = metaData.priceLabelTextColor
                self?.stockLabel.textColor = metaData.stockLabelTextColor
                self?.titleLabel.text = metaData.title
                self?.stockLabel.text = metaData.stock
            case .error(_):
                self?.thumbnailImageView.image = nil
            default:
                break
            }
        }
    }

    func configureCell() {
        viewModel?.configureCell()
    }

    private func configureView() {
        contentView.backgroundColor = Style.defaultBackgroundColor
        layer.borderColor = Style.Views.borderColor
        layer.borderWidth = Style.Views.borderWidth
        layer.cornerRadius = Style.Views.cornerRadius
    }

    private func addSubViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(priceLabelsStackView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stockLabel)
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
            stockLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                               constant: -Style.Views.defaultMargin),
            stockLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
}

extension ItemGridCollectionViewCell {
    // MARK: Style
    enum Style {
        static let defaultFont: UIFont = .preferredFont(forTextStyle: .body)
        static let stressedFont: UIFont = .preferredFont(forTextStyle: .title2)
        static let defaultBackgroundColor: UIColor = .systemBackground
        enum StackView {
            static let spacing: CGFloat = 5
        }
        enum Views {
            static let borderColor: CGColor = UIColor.systemGray3.cgColor
            static let defaultMargin: CGFloat = 10
            static let borderWidth: CGFloat = 1.0
            static let cornerRadius: CGFloat = 15
        }
        enum ImageView {
            static let sizeRatio: CGFloat = 0.5
        }
    }
}
