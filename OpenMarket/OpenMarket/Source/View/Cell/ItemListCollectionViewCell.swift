//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

final class ItemListCollectionViewCell: UICollectionViewCell, ItemCellDisplayable {
    static let identifier: String = "ItemListCell"

    // MARK: View Properties
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Style.stressedFont
        return label
    }()
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Style.defaultFont
        return label
    }()
    private var discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Style.defaultFont
        return label
    }()
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Style.defaultFont
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
        stackView.spacing = Style.StackView.defaultSpacing
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
                self?.priceLabel.attributedText = metaData.originalPrice
                self?.discountedPriceLabel.text = metaData.discountedPrice
                self?.thumbnailImageView.image = metaData.thumbnail
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
    }

    private func addSubViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(itemInfoStackView)
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
        discountedPriceLabel.setContentCompressionResistancePriority(Style.Priority.veryHigh, for: .horizontal)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stockLabel.setContentHuggingPriority(Style.Priority.veryHigh, for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(Style.Priority.veryHigh, for: .horizontal)
    }
}

extension ItemListCollectionViewCell {
    // MARK: Style
    private enum Style {
        static let stressedFont: UIFont = .preferredFont(forTextStyle: .title2)
        static let defaultFont: UIFont = .preferredFont(forTextStyle: .body)
        static let defaultBackgroundColor: UIColor = .systemBackground
        static let defaultTextColor: UIColor = .label
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
