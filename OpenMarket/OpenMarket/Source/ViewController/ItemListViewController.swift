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
    private var gridBarButtonItem: UIBarButtonItem = .init()
    private var listBarButtonItem: UIBarButtonItem = .init()
    private var plusBarButtonItem: UIBarButtonItem = .init()
    private var collectionView: UICollectionView = .init()
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
        let gridImage = UIImage(systemName: Style.gridImage)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let plusImage = UIImage(systemName: Style.plusImage)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let listImage = UIImage(systemName: Style.listImage)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        gridBarButtonItem.image = gridImage
        plusBarButtonItem.image = plusImage
        listBarButtonItem.image = listImage
        gridBarButtonItem.target = self
        listBarButtonItem.target = self
        gridBarButtonItem.action = #selector(touchGridButton(_:))
        listBarButtonItem.action = #selector(touchListButton(_:))
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
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(ok)
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
}

extension ItemListViewController: UICollectionViewDelegate {
    
}

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
