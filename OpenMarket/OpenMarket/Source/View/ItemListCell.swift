//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/28.
//

import UIKit

class ItemListCell: UICollectionViewCell {
    static let identifier: String = "ItemListCellViewCell"

    private var imageView: UIImageView = .init()
    private var titleLabel: UILabel = .init()
    private var priceLabel: UILabel = .init()
    private var discountedPriceLabel: UILabel = .init()
    private var stockLabel: UILabel = .init()
    private lazy var stackView: UIStackView = .init(arrangedSubviews: [priceLabel, discountedPriceLabel])

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
        viewModel?.fire()
    }

    func configureViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(stockLabel)
        contentView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        discountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        priceLabel.font = .preferredFont(forTextStyle: .body)
        discountedPriceLabel.font = .preferredFont(forTextStyle: .body)
    }
    
    func configureConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 10),
            stockLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
        ])
    }
}
