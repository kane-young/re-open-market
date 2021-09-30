//
//  ViewController.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/23.
//

import UIKit

final class ItemListViewController: UIViewController {
    private enum CellStyle {
        case list
        case grid
    }

    // MARK: UI Properties
    private var changeCellLayoutButton: UIBarButtonItem = .init()
    private var addItemBarButtonItem: UIBarButtonItem = .init()
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Style.CollectionView.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.identifier)
        collectionView.register(ItemGridCell.self, forCellWithReuseIdentifier: ItemGridCell.identifier)
        return collectionView
    }()

    // MARK: Instance Properties
    private let viewModel: ItemListViewModel = .init()
    private var cellStyle: CellStyle = .list

    // MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        addSubViews()
        viewModelBind()
        configureCollectionView()
        configureCollectionViewConstraints()
    }

    // MARK: Initialize ViewController
    private func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }

    private func configureNavigationBar() {
        changeCellLayoutButton.action = #selector(touchChangeCellLayoutButton(_:))
        addItemBarButtonItem.action = #selector(touchAddItemBarButtonItem(_:))
        changeCellLayoutButton.image = Style.BarButtonItem.gridImage
        addItemBarButtonItem.image = Style.BarButtonItem.plusImage
        changeCellLayoutButton.tintColor = Style.BarButtonItem.tintColor
        addItemBarButtonItem.tintColor = Style.BarButtonItem.tintColor
        changeCellLayoutButton.target = self
        addItemBarButtonItem.target = self
        navigationItem.rightBarButtonItems = [changeCellLayoutButton, addItemBarButtonItem]
    }

    private func viewModelBind() {
        viewModel.bind { [weak self] state in
            switch state {
            case .initial(let indexPaths):
                self?.activityIndicator.stopAnimating()
                self?.collectionView.isHidden = false
                self?.collectionView.insertItems(at: indexPaths)
            case .update(let indexPaths):
                self?.collectionView.insertItems(at: indexPaths)
            case .error(let error):
                let alertController = UIAlertController(title: Style.AlertMessage.title,
                                                        message: error.message,
                                                        preferredStyle: .alert)
                let okay = UIAlertAction(title: Style.AlertMessage.alertActionTitle,
                                         style: .default,
                                         handler: nil)
                alertController.addAction(okay)
                self?.present(alertController, animated: true, completion: nil)
            default:
                break
            }
        }
        collectionView.isHidden = true
        activityIndicator.startAnimating()
        viewModel.loadItems()
    }

    private func configureView() {
        self.view.backgroundColor = .white
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func configureCollectionViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }

    @objc private func touchChangeCellLayoutButton(_ sender: UIBarButtonItem) {
        changeRightBarButtonItemImage()
        changeCellStyle()
        collectionView.reloadData()
    }

    @objc private func touchAddItemBarButtonItem(_ sender: UIBarButtonItem) {
    }

    private func changeCellStyle() {
        switch cellStyle {
        case .list:
            cellStyle = .grid
        case .grid:
            cellStyle = .list
        }
    }

    private func changeRightBarButtonItemImage() {
        switch cellStyle {
        case .list:
            changeCellLayoutButton.image = Style.BarButtonItem.gridImage
        case .grid:
            changeCellLayoutButton.image = Style.BarButtonItem.listImage
        }
    }
}

extension ItemListViewController: UICollectionViewDelegate {
    // MARK: CollectionViewDelegate Method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if viewModel.items.count == indexPath.item + 2 {
            viewModel.loadItems()
        }
    }
}

extension ItemListViewController: UICollectionViewDataSource {
    // MARK: CollectionViewDataSource Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemCellDisplayable
        switch cellStyle {
        case .list:
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.identifier,
                                                                    for: indexPath) as? ItemListCell else {
                return UICollectionViewCell()
            }
            cell = listCell
        case .grid:
            guard let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCell.identifier,
                                                                    for: indexPath) as? ItemGridCell else {
                return UICollectionViewCell()
            }
            cell = gridCell
        }
        let item = viewModel.items[indexPath.item]
        let itemListCellViewModel = ItemListCellViewModel(item: item)
        cell.bind(itemListCellViewModel)
        cell.fire()
        return cell
    }
}

extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    // MARK: CollectionViewDelegateFlowLayout Method
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellStyle {
        case .list:
            return .init(width: collectionView.bounds.width * Style.Cell.listWidthRatio,
                         height: collectionView.bounds.height * Style.Cell.listHeightRatio)
        case .grid:
            return .init(width: collectionView.bounds.width * Style.Cell.gridWidthRatio + Style.Cell.gridWidthConstant,
                         height: collectionView.bounds.height * Style.Cell.gridHeightRatio + Style.Cell.gridHeightConstant)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch cellStyle {
        case .list:
            return Style.CollectionView.gridLayoutMinimumLineSpacing
        case .grid:
            return Style.CollectionView.listLayoutMinimumLineSpacing
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch cellStyle {
        case .list:
            return Style.CollectionView.listLayoutInsets
        case .grid:
            return Style.CollectionView.gridLayoutInsets
        }
    }
}

extension ItemListViewController {
    private enum Style {
        enum BarButtonItem {
            static let gridImage = UIImage(systemName: "square.grid.2x2")
            static let plusImage = UIImage(systemName: "plus")
            static let listImage = UIImage(systemName: "list.dash")
            static let tintColor = UIColor.black
        }
        enum AlertMessage {
            static let title = "에러 발생"
            static let alertActionTitle = "OK"
        }
        enum CollectionView {
            static let backgroundColor = UIColor.white
            static let listLayoutMinimumLineSpacing: CGFloat = 10
            static let gridLayoutMinimumLineSpacing: CGFloat = 0
            static let listLayoutInsets: UIEdgeInsets = .zero
            static let gridLayoutInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        }
        enum Cell {
            static let listWidthRatio: CGFloat = 1
            static let listHeightRatio: CGFloat = 1/6
            static let gridWidthRatio: CGFloat = 1/2
            static let gridWidthConstant: CGFloat = -20
            static let gridHeightRatio: CGFloat = 1/2
            static let gridHeightConstant: CGFloat = -20
        }
    }
}
