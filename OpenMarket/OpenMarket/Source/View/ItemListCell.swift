//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

class ItemListCell: UICollectionViewCell {
    static let identifier: String = "ItemListCell"

    private var imageView: UIImageView = {
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
        stackView.spacing = 5
        return stackView
    }()
    private lazy var itemInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, priceLabelsStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
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
        imageView.image = nil
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
                self?.imageView.image = metaData.image
                self?.titleLabel.text = metaData.title
                self?.priceLabel.text = metaData.originalPrice
                self?.stockLabel.text = metaData.stock
                self?.stockLabel.textColor = metaData.stockLabelTextColor
                self?.discountedPriceLabel.isHidden = metaData.isneededDiscountedLabel
                self?.discountedPriceLabel.attributedText = metaData.discountedPrice
            case .error(_):
                self?.imageView.image = nil
            default:
                break
            }
        }
    }

    func fire() {
        viewModel?.configureCell()
    }

    func configureViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(itemInfoStackView)
        contentView.backgroundColor = .white
    }

    func configureConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -10),
            itemInfoStackView.topAnchor.constraint(equalTo: imageView.topAnchor),
            itemInfoStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            itemInfoStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            itemInfoStackView.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor, constant: -10),
            stockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            stockLabel.topAnchor.constraint(equalTo: imageView.topAnchor)
        ])
        stockLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
