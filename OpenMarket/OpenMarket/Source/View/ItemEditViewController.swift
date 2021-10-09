//
//  ItemEditViewController.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/08.
//

import UIKit

class ItemEditViewController: UIViewController {
    enum Mode {
        case register
        case update
    }

    // MARK: Properties
    private let mode: Mode

    // MARK: Views Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    private let photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목을 입력하세요"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "수량을 입력하세요"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.keyboardType = .decimalPad
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private let currencyPickerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "화폐"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.textAlignment = .center
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.font = .preferredFont(forTextStyle: .body)
        textField.placeholder = "가격을 입력하세요"
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.font = .preferredFont(forTextStyle: .body)
        textField.placeholder = "할인가격을 입력하세요(선택 사항)"
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private let descriptionsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceTextField, discountedPriceTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyPickerTextField, priceStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureView()
        configureConstraints()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        descriptionsTextView.delegate = self
    }

    private func addSubviews() {
        scrollView.addSubview(photoCollectionView)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(stockTextField)
        scrollView.addSubview(stackView)
        scrollView.addSubview(descriptionsTextView)
        view.addSubview(scrollView)
    }

    private func configureConstraints() {
        configureScrollViewConstraints()
        configurePhotoCollectionViewConstraints()
        configureTitleTextFieldConstraints()
        configureStockTextFieldConstraints()
        configurePriceViewsConstraints()
        configureDescriptionTextViewConstraints()
    }

    private func configureScrollViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: photoCollectionView.topAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionsTextView.bottomAnchor)
        ])
    }

    private func configurePhotoCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: titleTextField.topAnchor, constant: -10),
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }

    private func configureTitleTextFieldConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            titleTextField.bottomAnchor.constraint(equalTo: stockTextField.topAnchor, constant: -20)
        ])
    }

    private func configureStockTextFieldConstraints() {
        NSLayoutConstraint.activate([
            stockTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stockTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10)
        ])
    }

    private func configurePriceViewsConstraints() {
        NSLayoutConstraint.activate([
            currencyPickerTextField.widthAnchor.constraint(equalToConstant: 80),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: stockTextField.bottomAnchor, constant: 20)
        ])
    }

    private func configureDescriptionTextViewConstraints() {
        NSLayoutConstraint.activate([
            descriptionsTextView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            descriptionsTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            descriptionsTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            descriptionsTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension ItemEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
