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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Style.Label.titleTextColor
        label.numberOfLines = .zero
        label.font = Style.stressedFont
        return label
    }()
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Style.Label.defaultTextColor
        label.font = Style.defaultFont
        return label
    }()
    private var discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Style.Label.defaultTextColor
        label.font = Style.defaultFont
        return label
    }()
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Style.Label.defaultTextColor
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
        contentView.addSubview(priceLabelsStackView)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stockLabel)
    }

    private func configureConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                        constant: Style.Margin.normal),
            thumbnailImageView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                    constant: Style.Margin.normal),
            thumbnailImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                       constant: -Style.Margin.normal),
            thumbnailImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor,
                                                         constant: -Style.Margin.betweenImageViewTitle),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor,
                                                 constant: -Style.Margin.normal),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: priceLabelsStackView.topAnchor,
                                               constant: -Style.Margin.normal),
            stockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                 constant: -Style.Margin.normal),
            stockLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            priceLabelsStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor,
                                                          constant: Style.Margin.betweenImageViewTitle),
            priceLabelsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                           constant: -Style.Margin.normal),
            priceLabelsStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                         constant: -Style.Margin.normal)
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
        static let defaultFont: UIFont = .preferredFont(forTextStyle: .caption1)
        static let stressedFont: UIFont = .preferredFont(forTextStyle: .body)
        static let defaultBackgroundColor: UIColor = .systemBackground
        enum Label {
            static let titleTextColor: UIColor = .label
            static let defaultTextColor: UIColor = .systemGray
        }
        enum StackView {
            static let defaultSpacing: CGFloat = 20
        }
        enum Margin {
            static let normal: CGFloat = 10
            static let betweenImageViewTitle: CGFloat = 20
        }
        enum Priority {
            static let veryHigh: UILayoutPriority = UILayoutPriority(1000)
        }
    }
}
