//
// ItemDetailViewController.swift
// OpenMarket
//
// Created by 이영우 on 2021/10/13.
//

import UIKit

class ItemDetailViewController: UIViewController {
    // MARK: View Properties
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.backgroundColor = Style.defaultBackgroundColor
        return scrollView
    }()
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = Style.defaultBackgroundColor
        collectionView.isDirectionalLockEnabled = true
        collectionView.register(ItemDetailCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemDetailCollectionViewCell.identifier)
        return collectionView
    }()
    private let pageControl: UIPageControl = {
        let pageControl: UIPageControl = .init()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = Style.PageControl.remainPageColor
        pageControl.currentPageIndicatorTintColor = Style.PageControl.currentPageColor
        return pageControl
    }()
    private let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = Style.stressedFont
        label.numberOfLines = .zero
        return label
    }()
    private let priceLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = Style.defaultFont
        return label
    }()
    private let discountedPriceLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = Style.defaultFont
        return label
    }()
    private lazy var priceStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [priceLabel, discountedPriceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Style.defaultViewsMargin
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    private let stockLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = Style.defaultFont
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = Style.defaultFont
        label.numberOfLines = .zero
        return label
    }()

    // MARK: Properties
    private let viewModel: ItemDetailViewModel

    init(id: Int) {
        self.viewModel = ItemDetailViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    // MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBind()
        addSubviews()
        configureViews()
        configureConstraints()
        configureNavigationBar()
    }

    // MARK: Configure Views
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(priceStackView)
        scrollView.addSubview(stockLabel)
        scrollView.addSubview(descriptionLabel)
    }

    private func configureViews() {
        view.backgroundColor = Style.defaultBackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func viewModelBind() {
        viewModel.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .update(let metaData):
                self.discountedPriceLabel.isHidden = !metaData.isNeededDiscountedLabel
                self.discountedPriceLabel.text = metaData.discountedPrice
                self.stockLabel.textColor = metaData.stockLabelTextColor
                self.priceLabel.textColor = metaData.priceLabelTextColor
                self.pageControl.numberOfPages = metaData.imageCount
                self.descriptionLabel.text = metaData.descriptions
                self.priceLabel.attributedText = metaData.price
                self.titleLabel.text = metaData.title
                self.stockLabel.text = metaData.stock
                self.collectionView.reloadData()
            case .itemNetworkError(let error):
                self.alertErrorMessage(error)
            default:
                break
            }
        }
        viewModel.loadItem()
    }

    private func configureNavigationBar() {
        guard let moreImage = Style.MoreBarButtonItem.image else { return }
        let menuBarButtonItem: UIBarButtonItem = .init(image: moreImage, style: .plain, target: self,
                                                       action: #selector(touchMenuBarButtonItem(_:)))
        menuBarButtonItem.tintColor = Style.defaultTintColor
        navigationItem.rightBarButtonItem = menuBarButtonItem
    }

    @objc private func touchMenuBarButtonItem(_ sender: UIBarButtonItem) {
    }

    private func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                               constant: -Style.defaultViewsMargin),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                                                  constant: -Style.defaultViewsMargin),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                constant: Style.defaultViewsMargin),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                 constant: -Style.defaultViewsMargin),
            titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor,
                                               constant: -Style.defaultViewsMargin),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            collectionView.bottomAnchor.constraint(equalTo: priceStackView.topAnchor,
                                                   constant: -Style.defaultViewsMargin),
            priceStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                    constant: Style.defaultViewsMargin),
            priceStackView.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor,
                                                     constant: -Style.defaultViewsMargin),
            priceStackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor,
                                                   constant: -(Style.defaultViewsMargin * 2)),
            stockLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                 constant: -Style.defaultViewsMargin),
            stockLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor,
                                            constant: Style.defaultViewsMargin),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                       constant: -Style.defaultViewsMargin),
            pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor,
                                                constant: -Style.defaultViewsMargin),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

extension ItemDetailViewController: UICollectionViewDelegate {
    // MARK: CollectionView Delegate Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
}

extension ItemDetailViewController: UICollectionViewDataSource {
    // MARK: CollectionView DataSource Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailCollectionViewCell.identifier, for: indexPath) as? ItemDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = viewModel.images[indexPath.item]
        cell.configureCell(with: image)
        return cell
    }
}

extension ItemDetailViewController: UICollectionViewDelegateFlowLayout {
    // MARK: CollectionView Flow Layout Method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width,
                      height: collectionView.bounds.height)
    }
}

extension ItemDetailViewController {
    // MARK: Style
    enum Style {
        static let defaultBackgroundColor: UIColor = .systemBackground
        static let defaultTintColor: UIColor = .label
        static let defaultFont: UIFont = .preferredFont(forTextStyle: .body)
        static let stressedFont: UIFont = .preferredFont(forTextStyle: .largeTitle)
        static let defaultViewsMargin: CGFloat = 10
        enum MoreBarButtonItem {
            static let image: UIImage? = .init(named: "ellipsis")
        }
        enum PageControl {
            static let currentPageColor: UIColor = .systemBlue
            static let remainPageColor: UIColor = .systemGray
        }
        enum StockLabel {
            static let soldOutColor: UIColor = .systemYellow
            static let normalColor: UIColor = .label
        }
        enum PriceLabel {
            static let strikeThroughColor: UIColor = .systemRed
            static let normalColor: UIColor = .label
        }
    }
}
