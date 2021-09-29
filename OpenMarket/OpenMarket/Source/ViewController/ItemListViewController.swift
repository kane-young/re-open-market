//
//  ViewController.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/23.
//

import UIKit

final class ItemListViewController: UIViewController {
    private enum Style {
        enum BarButtonItemImage {
            static let gridImage = UIImage(systemName: "square.grid.2x2")
            static let plusImage = UIImage(systemName: "plus")
            static let listImage = UIImage(systemName: "list.dash")
        }
    }

    private enum CellStyle {
        case list
        case grid
    }

    // MARK: UI Properties
    private var changeCellLayoutButton: UIBarButtonItem = UIBarButtonItem()
    private var addItemBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.identifier)
        collectionView.register(ItemGridCell.self, forCellWithReuseIdentifier: ItemGridCell.identifier)
        return collectionView
    }()

    private let viewModel: ItemListViewModel = .init()
    private var cellStyle: CellStyle = .list

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        addSubViews()
        viewModelBind()
        configureCollectionView()
        configureCollectionViewConstraints()
    }

    private func addSubViews() {
        view.addSubview(collectionView)
    }

    private func configureNavigationBar() {
        changeCellLayoutButton.action = #selector(touchChangeCellLayoutButton(_:))
        addItemBarButtonItem.action = #selector(touchAddItemBarButtonItem(_:))
        changeCellLayoutButton.image = Style.BarButtonItemImage.gridImage
        addItemBarButtonItem.image = Style.BarButtonItemImage.plusImage
        changeCellLayoutButton.tintColor = .black
        addItemBarButtonItem.tintColor = .black
        changeCellLayoutButton.target = self
        addItemBarButtonItem.target = self
        navigationItem.rightBarButtonItems = [changeCellLayoutButton, addItemBarButtonItem]
    }

    private func viewModelBind() {
        viewModel.bind { state in
            switch state {
            case .update(let indexPaths):
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.insertItems(at: indexPaths)
                }
            case .error(let error):
                DispatchQueue.main.async { [weak self] in
                    let alertController = UIAlertController(title: "에러", message: error.localizedDescription, preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okay)
                    self?.present(alertController, animated: true, completion: nil)
                }
            default:
                break
            }
        }
        viewModel.loadPage()
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
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
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
            changeCellLayoutButton.image = Style.BarButtonItemImage.gridImage
        case .grid:
            changeCellLayoutButton.image = Style.BarButtonItemImage.listImage
        }
    }
}

extension ItemListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemsCellDisplayable
        switch cellStyle {
        case .list:
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.identifier, for: indexPath) as? ItemListCell else {
                return UICollectionViewCell()
            }
            cell = listCell
        case .grid:
            guard let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCell.identifier, for: indexPath) as? ItemGridCell else {
                return UICollectionViewCell()
            }
            cell = gridCell
        }
        let item = viewModel.items[indexPath.item]
        let itemListCellViewModel = ItemListCellViewModel(marketItem: item)
        cell.bind(itemListCellViewModel)
        cell.fire()
        return cell
    }
}

extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellStyle {
        case .list:
            return .init(width: collectionView.bounds.width, height: collectionView.bounds.height / 6)
        case .grid:
            return .init(width: collectionView.bounds.width/2 - 20, height: collectionView.bounds.height / 2 - 20)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if viewModel.items.count == indexPath.item + 2 {
            viewModel.loadPage()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch cellStyle {
        case .list:
            return .zero
        case .grid:
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch cellStyle {
        case .list:
            return .zero
        case .grid:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
}
