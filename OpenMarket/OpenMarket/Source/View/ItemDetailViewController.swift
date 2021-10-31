//
// ItemDetailViewController.swift
// OpenMarket
//
// Created by 이영우 on 2021/10/13.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    func itemStateDidChanged()
}

final class ItemDetailViewController: UIViewController {
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
        collectionView.register(ItemDetailPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemDetailPhotoCollectionViewCell.identifier)
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
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = Style.defaultTintColor
        return indicator
    }()

    // MARK: Properties
    private var isUpdated: Bool = false
    private let viewModel: ItemDetailViewModel
    weak var delegate: ItemDetailViewControllerDelegate?

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
        viewModel.loadItem()
    }

    // MARK: Configure Views
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(activityIndicator)
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
                self.activityIndicator.stopAnimating()
                self.discountedPriceLabel.isHidden = !metaData.isNeededDiscountedLabel
                self.discountedPriceLabel.text = metaData.discountedPrice
                self.stockLabel.textColor = metaData.stockLabelTextColor
                self.priceLabel.textColor = metaData.priceLabelTextColor
                self.descriptionLabel.text = metaData.descriptions
                self.priceLabel.attributedText = metaData.price
                self.titleLabel.text = metaData.title
                self.stockLabel.text = metaData.stock
                self.pageControl.numberOfPages = self.viewModel.images.count
                self.collectionView.reloadData()
            case .delete:
                self.alertSuccessDeleteItem()
            case .error(let error) where error == ItemDetailViewModelError.useCaseError(.networkError(.invalidResponseStatuscode(404))):
                self.alertIncorrectPasswordMessage { _ in
                    self.alertCheckPassword()
                }
            case .error(let error):
                self.alertErrorMessage(error)
            default:
                break
            }
        }
    }

    private func configureConstraints() {
        configureLabelsConstraints()
        configureScrollViewConstraints()
        configureCollectionViewConstraints()
        configurePriceStackViewConstraints()
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor,
                                                constant: -Style.defaultViewsMargin),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private func configureScrollViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                               constant: -Style.defaultViewsMargin),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                                                  constant: Style.defaultViewsMargin)
        ])
    }

    private func configureCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: priceStackView.topAnchor,
                                                   constant: -Style.defaultViewsMargin)
        ])
    }

    private func configurePriceStackViewConstraints() {
        NSLayoutConstraint.activate([
            priceStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                    constant: Style.defaultViewsMargin),
            priceStackView.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor,
                                                     constant: -Style.defaultViewsMargin),
            priceStackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor,
                                                   constant: -(Style.defaultViewsMargin * 2))
        ])
    }

    private func configureLabelsConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                constant: Style.defaultViewsMargin),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                 constant: -Style.defaultViewsMargin),
            titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor,
                                               constant: -Style.defaultViewsMargin),
            stockLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                 constant: -Style.defaultViewsMargin),
            stockLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor,
                                            constant: Style.defaultViewsMargin),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                       constant: -Style.defaultViewsMargin)
        ])
    }
}

extension ItemDetailViewController {
    // MARK: Method associated with Binding
    private func configureNavigationBar() {
        let moreBarButtonItem: UIBarButtonItem = .init(image: Style.MoreBarButtonItem.image, style: .plain,
                                                       target: self, action: #selector(touchMenuBarButtonItem(_:)))
        moreBarButtonItem.tintColor = Style.defaultTintColor
        navigationItem.rightBarButtonItem = moreBarButtonItem
        navigationItem.hidesBackButton = true
        let backButtonItem = UIBarButtonItem(title: Style.BackBarButtonItem.title, style: .plain, target: self,
                                             action: #selector(touchBackBarButtonItem))
        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc private func touchMenuBarButtonItem(_ sender: UIBarButtonItem) {
        alertUpdateOrDelete()
    }

    @objc private func touchBackBarButtonItem(_ sender: UIBarButtonItem) {
        if isUpdated {
            delegate?.itemStateDidChanged()
        }
        navigationController?.popViewController(animated: true)
    }

    private func alertSuccessDeleteItem() {
        let alertController: UIAlertController = .init(title: Style.Alert.DeleteItem.title,
                                                       message: Style.Alert.DeleteItem.message, preferredStyle: .alert)
        let okay: UIAlertAction = .init(title: Style.Alert.Action.okayTitle, style: .default) { [weak self] _ in
            self?.delegate?.itemStateDidChanged()
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okay)
        present(alertController, animated: true, completion: nil)
    }

    private func alertUpdateOrDelete() {
        let alertController: UIAlertController = .init(title: nil, message: nil, preferredStyle: .actionSheet)
        let update: UIAlertAction = .init(title: Style.Alert.Action.updateTitle, style: .default) { [weak self] _ in
            self?.updateItem()
        }
        let delete: UIAlertAction = .init(title: Style.Alert.Action.deleteTitle, style: .destructive) { [weak self] _ in
            self?.deleteItem()
        }
        let cancel: UIAlertAction = .init(title: Style.Alert.Action.cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(update)
        alertController.addAction(delete)
        alertController.addAction(cancel)

        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.barButtonItem = navigationItem.rightBarButtonItem
            }
        }
        present(alertController, animated: true)
    }

    private func updateItem() {
        let itemEditViewModel = ItemEditViewModel(id: viewModel.id)
        itemEditViewModel.loadItem()
        let itemEditViewController: ItemEditViewController = .init(mode: .update, viewModel: itemEditViewModel)
        itemEditViewController.delegate = self
        self.navigationController?.pushViewController(itemEditViewController, animated: true)
    }

    private func deleteItem() {
        alertCheckPassword()
    }

    private func alertCheckPassword() {
        let alertController: UIAlertController = .init(title: Style.Alert.InputPassword.title,
                                                message: Style.Alert.InputPassword.message,
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = Style.Alert.InputPassword.placeHolder
            textField.isSecureTextEntry = true
        }
        let register: UIAlertAction = .init(title: Style.Alert.Action.deleteTitle, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            guard let password = alertController.textFields?[0].text else { return }
            self.viewModel.deleteItem(password: password)
        }
        let cancel: UIAlertAction = .init(title: Style.Alert.Action.cancelTitle, style: .default, handler: nil)
        alertController.addAction(register)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

extension ItemDetailViewController: UICollectionViewDelegate {
    // MARK: CollectionView Delegate Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.safeAreaLayoutGuide.layoutFrame.width
        pageControl.currentPage = Int(scrollPos)
    }
}

extension ItemDetailViewController: UICollectionViewDataSource {
    // MARK: CollectionView DataSource Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailPhotoCollectionViewCell.identifier, for: indexPath) as? ItemDetailPhotoCollectionViewCell else {
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
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

extension ItemDetailViewController: ItemEditViewControllerDelegate {
    // MARK: Item Edit View Controller Delegate Method
    func didSuccessEdit(item: Item) {
        isUpdated = true
        viewModel.reset()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.viewModel.loadItem()
        }
    }
}
