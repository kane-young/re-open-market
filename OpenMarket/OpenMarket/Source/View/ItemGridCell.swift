//
//  ItemGridCell.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/29.
//

import UIKit

protocol ItemsCellDisplayable: UICollectionViewCell {
    func bind(_ viewModel: ItemListCellViewModel)
    func fire()
}

class ItemGridCell: UICollectionViewCell, ItemsCellDisplayable {
    static let identifier: String = "ItemGridCell"

    private var imageView: UIImageView = {
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

    private func configureViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(priceLabelsStackView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stockLabel)
        contentView.backgroundColor = .white
    }

    private func configureConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let contentView = self.contentView
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            priceLabelsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            priceLabelsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabelsStackView.bottomAnchor.constraint(equalTo: stockLabel.topAnchor, constant: -10),
            priceLabelsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            stockLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            stockLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            stockLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
