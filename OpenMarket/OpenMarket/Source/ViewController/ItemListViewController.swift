//
//  ViewController.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/23.
//

import UIKit

final class ItemListViewController: UIViewController {
    private enum Style {
        static let gridImage = "square.grid.2x2"
        static let plusImage = "plus"
        static let listImage = "list.dash"
    }

    // MARK: UI Properties
    private var gridBarButtonItem: UIBarButtonItem = {
        let image = UIImage(systemName: Style.gridImage)?.withTintColor(.black)
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(touchGridButton(_:)))
        return barButtonItem
    }()
    private var listBarButtonItem: UIBarButtonItem = {
        let image = UIImage(systemName: Style.listImage)?.withTintColor(.black)
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(touchListButton(_:)))
        return barButtonItem
    }()
    private var plusBarButtonItem: UIBarButtonItem = {
        let image = UIImage(systemName: Style.plusImage)?.withTintColor(.black)
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(touchPlusButton(_:)))
        return barButtonItem
    }()
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.identifier)
        return collectionView
    }()

    private let viewModel: ItemListViewModel = .init()

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
        navigationItem.rightBarButtonItems = [plusBarButtonItem, gridBarButtonItem]
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

    @objc private func touchGridButton(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [plusBarButtonItem, listBarButtonItem]
    }

    @objc private func touchListButton(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [plusBarButtonItem, gridBarButtonItem]
    }

    @objc private func touchPlusButton(_ sender: UIBarButtonItem) {

    }
}

extension ItemListViewController: UICollectionViewDelegate {
}

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.identifier, for: indexPath) as? ItemListCell else {
            return UICollectionViewCell()
        }
        let item = viewModel.items[indexPath.item]
        let itemListCellViewModel = ItemListCellViewModel(marketItem: item)
        cell.bind(itemListCellViewModel)
        cell.fire()
        return cell
    }
}

extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width, height: collectionView.bounds.height / 6)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.items.count == indexPath.item + 2 {
            viewModel.loadPage()
        }
    }
}
