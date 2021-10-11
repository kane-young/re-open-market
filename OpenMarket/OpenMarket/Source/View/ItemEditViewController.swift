//
//  ItemEditViewController.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/08.
//

import UIKit

class ItemEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    enum Mode {
        case register
        case update
    }

    // MARK: Properties
    private let mode: Mode
    private let viewModel: ItemEditViewModel = .init()

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
        collectionView.register(ItemPhotoCollectionViewCell.self, forCellWithReuseIdentifier: ItemPhotoCollectionViewCell.identifier)
        collectionView.register(AddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AddPhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private let collectionViewBorderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제품명"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        textField.tintColor = .clear
        return textField
    }()
    private let titleBorderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제품 수량"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.keyboardType = .decimalPad
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private let stockBorderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
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
        textField.placeholder = "제품 가격"
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.font = .preferredFont(forTextStyle: .body)
        textField.placeholder = "할인 가격(선택 사항)"
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private let priceBorderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    private let descriptionsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .lightGray
        textView.text = "제품 설명을 입력하세요"
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceTextField, discountedPriceTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 40
        return stackView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyPickerTextField, priceStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    private let imagePickerController: UIImagePickerController = .init()
    private var scrollViewBottomAnchor: NSLayoutConstraint?

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
        configureViews()
        configureConstraints()
        addTapGestureRecognizer()
        viewModelBind()
        configureCurrencyTextFieldToolBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureKeyboardNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }

    private func configureViews() {
        view.backgroundColor = .systemBackground
        descriptionsTextView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        imagePickerController.delegate = self
    }

    private func addSubviews() {
        scrollView.addSubview(photoCollectionView)
        scrollView.addSubview(collectionViewBorderView)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(titleBorderView)
        scrollView.addSubview(stockTextField)
        scrollView.addSubview(stockBorderView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(priceBorderView)
        scrollView.addSubview(descriptionsTextView)
        view.addSubview(scrollView)
    }

    private func viewModelBind() {
        viewModel.bind { [weak self] state in
            switch state {
            case .add(let indexPath):
                self?.photoCollectionView.insertItems(at: [indexPath])
            case .delete(let indexPath):
                self?.photoCollectionView.deleteItems(at: [indexPath])
            default:
                break
            }
        }
    }

    private func configureCurrencyTextFieldToolBar() {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyPickerTextField.inputView = pickerView
        let bar = UIToolbar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.sizeToFit()
        bar.isUserInteractionEnabled = true
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(touchDoneBarButtonItem(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([space, done], animated: false)
        bar.sizeToFit()
        currencyPickerTextField.inputAccessoryView = bar
    }

    let datas: [String] = ["KRW", "JPW", "USD"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datas.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datas[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyPickerTextField.text = datas[row]
    }

    @objc private func touchDoneBarButtonItem(_ sender: UIBarButtonItem) {
        currencyPickerTextField.resignFirstResponder()
    }
}

extension ItemEditViewController {
    // MARK: Set Constraints Method
    private func configureConstraints() {
        borderViewsConstraints()
        configureScrollViewConstraints()
        configurePhotoCollectionViewConstraints()
        configureTitleTextFieldConstraints()
        configureStockTextFieldConstraints()
        configurePriceViewsConstraints()
        configureDescriptionTextViewConstraints()
    }

    private func configureScrollViewConstraints() {
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomAnchor?.isActive = true
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
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
            photoCollectionView.bottomAnchor.constraint(equalTo: collectionViewBorderView.topAnchor, constant: -20),
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }

    private func borderViewsConstraints() {
        NSLayoutConstraint.activate([
            collectionViewBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            collectionViewBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            collectionViewBorderView.bottomAnchor.constraint(equalTo: titleTextField.topAnchor, constant: -20),
            titleBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            titleBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            titleBorderView.bottomAnchor.constraint(equalTo: stockTextField.topAnchor, constant: -20),
            stockBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stockBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stockBorderView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            priceBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            priceBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            priceBorderView.bottomAnchor.constraint(equalTo: descriptionsTextView.topAnchor, constant: -20),
            collectionViewBorderView.heightAnchor.constraint(equalToConstant: 1),
            titleBorderView.heightAnchor.constraint(equalToConstant: 1),
            stockBorderView.heightAnchor.constraint(equalToConstant: 1),
            priceBorderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    private func configureTitleTextFieldConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            titleTextField.bottomAnchor.constraint(equalTo: titleBorderView.topAnchor, constant: -20)
        ])
    }

    private func configureStockTextFieldConstraints() {
        NSLayoutConstraint.activate([
            stockTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stockTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stockTextField.bottomAnchor.constraint(equalTo: stockBorderView.topAnchor, constant: -20)
        ])
    }

    private func configurePriceViewsConstraints() {
        NSLayoutConstraint.activate([
            currencyPickerTextField.widthAnchor.constraint(equalToConstant: 80),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: priceBorderView.topAnchor, constant: -20)
        ])
    }

    private func configureDescriptionTextViewConstraints() {
        NSLayoutConstraint.activate([
            descriptionsTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            descriptionsTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            descriptionsTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

extension ItemEditViewController {
    // MARK: Set Keyboard associated Method
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let endFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else {
            return
        }
        let endFrame = endFrameValue.cgRectValue
        scrollViewBottomAnchor?.isActive = false
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -endFrame.height)
        scrollViewBottomAnchor?.isActive = true
        scrollView.contentInset.bottom = 30
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollViewBottomAnchor?.isActive = false
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomAnchor?.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(moveDownKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }

    @objc private func moveDownKeyboard() {
        view.endEditing(true)
    }
}

extension ItemEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "제품 설명을 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ItemEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        if indexPath.item == 0 {
            guard let addPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionViewCell.identifier, for: indexPath) as? AddPhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            viewModel.delegate = addPhotoCell
            cell = addPhotoCell
        } else {
            guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemPhotoCollectionViewCell.identifier, for: indexPath) as? ItemPhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            photoCell.addDeleteButtonTarget(target: self, action: #selector(touchDeletePhotoButton(_:)), for: .touchUpInside)
            photoCell.bind(ItemPhotoCellViewModel(image: viewModel.images[indexPath.item-1]))
            photoCell.configureCell()
            cell = photoCell
        }
        return cell
    }

    @objc private func touchDeletePhotoButton(_ sender: UIButton) {
        for index in 0..<viewModel.images.count {
            let indexPath = IndexPath(item: index + 1, section: 0)
            guard let cell = photoCollectionView.cellForItem(at: indexPath) as? ItemPhotoCollectionViewCell else { return }
            if cell.deleteButton == sender {
                viewModel.deleteImage(indexPath)
            }
        }
    }
}

extension ItemEditViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension ItemEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            image = originalImage
        }
        viewModel.addImage(image)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension ItemEditViewController: UICollectionViewDelegateFlowLayout {
    // MARK: CollectionViewDelegateFlowLayout Method
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.height * 3/4,
                     height: collectionView.bounds.height * 3/4)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 20, bottom: 0, right: 20)
    }
}
