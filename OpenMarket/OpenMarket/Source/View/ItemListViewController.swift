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
    private let addBarButtonItem: UIBarButtonItem = {
        let barButtonItem: UIBarButtonItem = .init(systemItem: .add)
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    private var segmentedControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = .init(items: [Style.SegmentedControl.listItem,
                                                                 Style.SegmentedControl.gridItem])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBackground], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        segmentedControl.selectedSegmentTintColor = .label
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init()
        indicator.color = Style.reverseDefaultColor
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Style.defaultColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemListCollectionViewCell.self, forCellWithReuseIdentifier: ItemListCollectionViewCell.identifier)
        collectionView.register(ItemGridCollectionViewCell.self, forCellWithReuseIdentifier: ItemGridCollectionViewCell.identifier)
        return collectionView
    }()

    // MARK: Properties
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
        addBarButtonItem.target = self
        addBarButtonItem.action = #selector(touchAddBarButtonItem(_:))
        navigationItem.rightBarButtonItem = addBarButtonItem
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue(_:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Style.defaultColor
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
        self.view.backgroundColor = Style.defaultColor
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
    }

    @objc private func touchAddBarButtonItem(_ sender: UIBarButtonItem) {
        let itemEditViewController = ItemEditViewController(mode: .register)
        self.navigationController?.pushViewController(itemEditViewController, animated: true)
    }
}

extension ItemListViewController: UICollectionViewDelegate {
    // MARK: CollectionViewDelegate Method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.item]
        let itemDetailViewController = ItemDetailViewController(id: item.id)
        navigationController?.pushViewController(itemDetailViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
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
        static let defaultColor: UIColor = .systemBackground
        static let reverseDefaultColor: UIColor = .label
        enum SegmentedControl {
            static let listItem = "LIST"
            static let gridItem = "GRID"
        }
        enum NavigationBar {
            static let title = "오픈마켓"
        }
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
            static let remainCellCount: Int = 10
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
