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

    private var gridBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    private var listBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    private var plusBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    private var collectionView: UICollectionView = UICollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        addSubViews()
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

    private func configureView() {
        self.view.backgroundColor = .white
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
