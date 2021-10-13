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
        collectionView.register(ItemDetailCollectionViewCell.self, forCellWithReuseIdentifier: ItemDetailCollectionViewCell.identifier)
        return collectionView
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "hi"
        return label
    }()

    // MARK: \Properties\
    let images: [UIImage] = [UIImage(systemName: "pencil")!, UIImage(systemName: "tray")!, UIImage(systemName: "note")!]

    // MARK: \Life Cycle Method\
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureViews()
        configureConstraints()
    }

    // MARK: \Configure Views\
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(descriptionLabel)
    }

    private func configureViews() {
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
    }

    private func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: collectionView.topAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            collectionView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
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
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailCollectionViewCell.identifier, for: indexPath) as? ItemDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = images[indexPath.item]
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
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
}
