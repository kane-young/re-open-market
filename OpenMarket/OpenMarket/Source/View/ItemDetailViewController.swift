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
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isDirectionalLockEnabled = true
        collectionView.register(ItemDetailCollectionViewCell.self, forCellWithReuseIdentifier: ItemDetailCollectionViewCell.identifier)
        return collectionView
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private let discountedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = .zero
        label.adjustsFontForContentSizeCategory = true
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
        scrollView.addSubview(collectionView)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(discountedLabel)
        scrollView.addSubview(stockLabel)
    }

    private func configureViews() {
        view.backgroundColor = .systemYellow
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = viewModel.images.count
    }

    private func viewModelBind() {
        viewModel.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loadImage(let indexPaths):
                self.collectionView.insertItems(at: indexPaths)
                self.pageControl.numberOfPages = self.viewModel.images.count
            case .update(let metaData):
                self.titleLabel.text = metaData.title
                self.stockLabel.text = metaData.stock
                self.priceLabel.text = metaData.price
                self.discountedLabel.text = metaData.discountedPrice
                self.descriptionLabel.text = metaData.descriptions
            case .itemNetworkError(let error):
                print("아이템 다운로드 실패 \(error.localizedDescription)")
            case .thumbnailNetworkError(let error):
                print("이미지 다운로드를 실패 \(error.message)")
            default:
                print("I don't know what happened")
            }
        }
        viewModel.loadItem()
    }

    private func configureNavigationBar() {
        let barButtonItem = UIBarButtonItem(systemItem: .add)
        barButtonItem.tintColor = .gray
        navigationItem.rightBarButtonItem = barButtonItem
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }

    private func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: collectionView.topAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor, constant: -10),
            stockLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: discountedLabel.topAnchor, constant: -10),
            discountedLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            discountedLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -5),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

extension ItemDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
}

extension ItemDetailViewController: UICollectionViewDataSource {
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width,
                      height: collectionView.bounds.height)
    }
}
