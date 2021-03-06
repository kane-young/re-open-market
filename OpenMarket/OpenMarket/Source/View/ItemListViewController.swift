//
//  ViewController.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/23.
//

import UIKit

final class ItemListViewController: UIViewController {
    // MARK: CellStyle
    private enum CellStyle {
        case list
        case grid
    }

    // MARK: Views Properties
    private let addBarButtonItem: UIBarButtonItem = {
        let barButtonItem: UIBarButtonItem = .init(systemItem: .add)
        barButtonItem.tintColor = Style.defaultTintColor
        return barButtonItem
    }()
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = .init(items: [Style.SegmentedControl.listItem,
                                                                 Style.SegmentedControl.gridItem])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.setTitleTextAttributes([.foregroundColor: Style.defaultBackgroundColor], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: Style.defaultTintColor], for: .normal)
        segmentedControl.selectedSegmentTintColor = Style.defaultTintColor
        segmentedControl.backgroundColor = Style.defaultBackgroundColor
        segmentedControl.selectedSegmentIndex = .zero
        return segmentedControl
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init()
        indicator.color = Style.defaultTintColor
        indicator.style = .large
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Style.defaultBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemListCollectionViewCell.self, forCellWithReuseIdentifier: ItemListCollectionViewCell.identifier)
        collectionView.register(ItemGridCollectionViewCell.self, forCellWithReuseIdentifier: ItemGridCollectionViewCell.identifier)
        return collectionView
    }()

    // MARK: Properties
    private let viewModel: ItemListViewModel = .init()
    private var cellStyle: CellStyle = .list
    private var currentPosition: IndexPath?

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
        addBarButtonItem.target = self
        addBarButtonItem.action = #selector(touchAddBarButtonItem)
        segmentedControl.setWidth(view.frame.width * 1/5, forSegmentAt: 0)
        segmentedControl.setWidth(view.frame.width * 1/5, forSegmentAt: 1)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue(_:)), for: .valueChanged)
        let refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self,
                                                   action: #selector(refreshItemList))
        navigationItem.setRightBarButtonItems([addBarButtonItem, refreshBarButtonItem], animated: true)
        navigationItem.titleView = segmentedControl
        navigationController?.navigationBar.tintColor = Style.defaultTintColor
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = Style.defaultBackgroundColor
    }

    private func viewModelBind() {
        viewModel.bind { [weak self] state in
            switch state {
            case .update(let indexPaths):
                self?.collectionView.insertItems(at: indexPaths)
                self?.activityIndicator.stopAnimating()
            case .refresh:
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
                self?.activityIndicator.stopAnimating()
            case .error(let error):
                self?.alertErrorMessage(error)
            default:
                break
            }
        }
        activityIndicator.startAnimating()
        viewModel.loadItems()
    }

    private func configureView() {
        self.view.backgroundColor = Style.defaultBackgroundColor
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshItemList), for: .valueChanged)
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

    @objc private func segmentedControlChangedValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            cellStyle = .list
            collectionView.reloadData()
        case 1:
            cellStyle = .grid
            collectionView.reloadData()
        default:
            return
        }
        guard let currentPosition = currentPosition else { return }
        collectionView.scrollToItem(at: currentPosition, at: .centeredVertically, animated: false)
    }

    @objc private func touchAddBarButtonItem() {
        let itemEditViewController = ItemEditViewController(mode: .register)
        itemEditViewController.delegate = self
        self.navigationController?.pushViewController(itemEditViewController, animated: true)
    }

    @objc private func refreshItemList() {
        collectionView.refreshControl?.beginRefreshing()
        activityIndicator.startAnimating()
        viewModel.reset()
    }
}

extension ItemListViewController: UICollectionViewDelegate {
    // MARK: CollectionViewDelegate Method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.item]
        let itemDetailViewController = ItemDetailViewController(id: item.id)
        itemDetailViewController.delegate = self
        navigationController?.pushViewController(itemDetailViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        switch cellStyle {
        case .list:
            currentPosition = IndexPath(item: indexPath.item - 3, section: .zero)
        case .grid:
            currentPosition = IndexPath(item: indexPath.item - 2, section: .zero)
        }
        if viewModel.items.count <= indexPath.item + Style.CollectionView.remainCellCount {
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
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCollectionViewCell.identifier,
                                                                    for: indexPath) as? ItemListCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell = listCell
        case .grid:
            guard let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCollectionViewCell.identifier,
                                                                    for: indexPath) as? ItemGridCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell = gridCell
        }
        let item = viewModel.items[indexPath.item]
        let itemListCellViewModel = ItemListCellViewModel(item: item)
        cell.bind(itemListCellViewModel)
        cell.configureCell()
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
            return .init(width: collectionView.bounds.width * Style.Cell.gridWidthRatio +
                         Style.Cell.gridWidthConstant,
                         height: collectionView.bounds.height * Style.Cell.gridHeightRatio + Style.Cell.gridHeightConstant)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch cellStyle {
        case .list:
            return Style.CollectionView.listLayoutMinimumLineSpacing
        case .grid:
            return Style.CollectionView.gridLayoutMinimumLineSpacing
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

extension ItemListViewController: ItemDetailViewControllerDelegate {
    // MARK: ItemDetailViewController Delegate Method - Detail View Controller을 통해서 수정을 했을 경우
    func itemStateDidChanged() {
        viewModel.reset()
    }
}

extension ItemListViewController: ItemEditViewControllerDelegate {
    // MARK: ItemEditViewController Delegate Method - List에서 Item 생성시
    func didSuccessEdit(item: Item) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let detailViewController = ItemDetailViewController(id: item.id)
            detailViewController.delegate = self
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension ItemListViewController {
    private enum Style {
        static let defaultBackgroundColor: UIColor = .systemBackground
        static let defaultTintColor: UIColor = .label
        enum SegmentedControl {
            static let listItem = "LIST"
            static let gridItem = "GRID"
        }
        enum CollectionView {
            static let listLayoutMinimumLineSpacing: CGFloat = 0
            static let gridLayoutMinimumLineSpacing: CGFloat = 10
            static let listLayoutInsets: UIEdgeInsets = .zero
            static let gridLayoutInsets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
            static let remainCellCount: Int = 10
        }
        enum Cell {
            static let listWidthRatio: CGFloat = 1
            static let listHeightRatio: CGFloat = 1/6
            static let gridWidthRatio: CGFloat = 1/2
            static let gridWidthConstant: CGFloat = -20
            static let gridHeightRatio: CGFloat = 2/5
            static let gridHeightConstant: CGFloat = -20
        }
    }
}
