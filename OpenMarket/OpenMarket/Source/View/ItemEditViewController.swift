//
//  ItemEditViewController.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/08.
//

import UIKit

protocol ItemEditViewControllerDelegate: AnyObject {
    func didEndRegister(item: Item)
}

final class ItemEditViewController: UIViewController {
    // MARK: Cell Layout Mode
    enum Mode {
        case register
        case update
    }

    // MARK: Views Properties
    private let discountedPriceTextField: UITextField = .init()
    private let currencyTextField: UITextField = .init()
    private let titleTextField: UITextField = .init()
    private let stockTextField: UITextField = .init()
    private let priceTextField: UITextField = .init()
    private let descriptionsTextView: UITextView = .init()
    private let imagePickerController: UIImagePickerController = .init()
    private let collectionViewBorderView: UIView = .init()
    private let priceBorderView: UIView = .init()
    private let titleBorderView: UIView = .init()
    private let stockBorderView: UIView = .init()
    private var scrollViewBottomAnchor: NSLayoutConstraint?
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.backgroundColor = Style.backgroundColor
        return scrollView
    }()
    private let photoCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        flowLayout.scrollDirection = .horizontal
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.register(ItemEditPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemEditPhotoCollectionViewCell.identifier)
        collectionView.register(AddPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: AddPhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = Style.backgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private lazy var priceStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [priceTextField, discountedPriceTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Style.Views.verticalSpacing * 2
        return stackView
    }()
    private lazy var moneyStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [currencyTextField, priceStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Style.MoneyStackView.spacing
        return stackView
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()

    // MARK: Properties
    private let mode: Mode
    private let viewModel: ItemEditViewModel
    weak var delegate: ItemEditViewControllerDelegate?

    // MARK: Initializer
    init(mode: Mode, viewModel: ItemEditViewModel = ItemEditViewModel()) {
        self.mode = mode
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("not use interface builder")
    }

    // MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureDelegates()
        configureTextFields()
        configureBorderViews()
        configureNavigationBar()
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

    // MARK: initialize ViewController
    private func configureDelegates() {
        view.backgroundColor = .systemBackground
        descriptionsTextView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        imagePickerController.delegate = self
    }

    private func addSubviews() {
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(photoCollectionView)
        scrollView.addSubview(collectionViewBorderView)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(titleBorderView)
        scrollView.addSubview(stockTextField)
        scrollView.addSubview(stockBorderView)
        scrollView.addSubview(moneyStackView)
        scrollView.addSubview(priceBorderView)
        scrollView.addSubview(descriptionsTextView)
        view.addSubview(scrollView)
    }

    private func configureTextFields() {
        descriptionsTextView.translatesAutoresizingMaskIntoConstraints = false
        discountedPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        currencyTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        stockTextField.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        discountedPriceTextField.placeholder = Style.DiscountedPriceTextField.placeHolder
        currencyTextField.placeholder = Style.CurrencyTextField.placeHolder
        titleTextField.placeholder = Style.TitleTextField.placeHolder
        stockTextField.placeholder = Style.StockTextField.placeHolder
        priceTextField.placeholder = Style.PriceTextField.placeHolder
        discountedPriceTextField.font = Style.defaultFont
        descriptionsTextView.font = Style.defaultFont
        currencyTextField.font = Style.defaultFont
        titleTextField.font = Style.defaultFont
        stockTextField.font = Style.defaultFont
        priceTextField.font = Style.defaultFont
        discountedPriceTextField.adjustsFontForContentSizeCategory = true
        descriptionsTextView.adjustsFontForContentSizeCategory = true
        currencyTextField.adjustsFontForContentSizeCategory = true
        titleTextField.adjustsFontForContentSizeCategory = true
        stockTextField.adjustsFontForContentSizeCategory = true
        priceTextField.adjustsFontForContentSizeCategory = true
        discountedPriceTextField.keyboardType = .numberPad
        stockTextField.keyboardType = .numberPad
        priceTextField.keyboardType = .numberPad
        currencyTextField.textAlignment = .center
        descriptionsTextView.showsVerticalScrollIndicator = false
        descriptionsTextView.isScrollEnabled = false
        if mode == .register {
            descriptionsTextView.text = Style.DescriptionsTextView.placeHolder
            descriptionsTextView.textColor = Style.DescriptionsTextView.placeHolderTextColor
        }
    }

    private func configureBorderViews() {
        collectionViewBorderView.translatesAutoresizingMaskIntoConstraints = false
        priceBorderView.translatesAutoresizingMaskIntoConstraints = false
        titleBorderView.translatesAutoresizingMaskIntoConstraints = false
        stockBorderView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewBorderView.backgroundColor = Style.BorderView.backgroundColor
        priceBorderView.backgroundColor = Style.BorderView.backgroundColor
        titleBorderView.backgroundColor = Style.BorderView.backgroundColor
        stockBorderView.backgroundColor = Style.BorderView.backgroundColor
    }

    private func viewModelBind() {
        viewModel.bind { [weak self] state in
            switch state {
            case .first:
                self?.activityIndicator.startAnimating()
            case .initial(let item):
                self?.activityIndicator.stopAnimating()
                self?.configureViewsForUpdate(item)
                self?.photoCollectionView.reloadData()
            case .addPhoto(let indexPath):
                self?.photoCollectionView.insertItems(at: [indexPath])
            case .deletePhoto(let indexPath):
                self?.photoCollectionView.deleteItems(at: [indexPath])
            case .satisfied:
                self?.alertInputPassword()
            case .dissatisfied:
                self?.alertDissatisfication()
            case .error(let error) where error == ItemEditViewModelError.editUseCaseError(.networkError(.invalidResponseStatuscode(404))):
                self?.activityIndicator.stopAnimating()
                self?.alertIncorrectPasswordMessage { _ in
                    self?.alertInputPassword()
                }
            case .error(let error):
                self?.alertErrorMessage(error)
            case .register(let item):
                self?.alertSuccessRegister(item: item)
            case .update(let item):
                self?.alertSuccessUpdate(item: item)
            default:
                break
            }
        }
    }

    private func alertSuccessRegister(item: Item) {
        let alertController = UIAlertController(title: "등록 완료", message: "아이템 등록에 성공하였습니다", preferredStyle: .alert)
        let okay = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.delegate?.didEndRegister(item: item)
            self?.navigationController?.popViewController(animated: false)
        }
        alertController.addAction(okay)
        present(alertController, animated: true, completion: nil)
    }

    private func alertSuccessUpdate(item: Item) {
        let alertController = UIAlertController(title: "수정 완료", message: "아이템 수정에 성공하였습니다", preferredStyle: .alert)
        let okay = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            self?.delegate?.didEndRegister(item: item)
        }
        alertController.addAction(okay)
        present(alertController, animated: true, completion: nil)
    }

    private func configureViewsForUpdate(_ item: Item) {
        titleTextField.text = item.title
        currencyTextField.text = item.currency
        priceTextField.text = String(item.price)
        stockTextField.text = String(item.stock)
        descriptionsTextView.text = item.descriptions
        if let discountedPrice = item.discountedPrice {
            discountedPriceTextField.text = String(discountedPrice)
        }
    }

    private func configureNavigationBar() {
        switch mode {
        case .register:
            let doneButton: UIBarButtonItem = .init(title: Style.RightBarButtonItem.registerTitle, style: .plain,
                                             target: self, action: #selector(touchRegisterItemButton(_:)))
            navigationItem.rightBarButtonItem = doneButton
        case .update:
            let updateButton: UIBarButtonItem = .init(title: Style.RightBarButtonItem.updateTitle, style: .plain,
                                                      target: self, action: #selector(touchUpdateItemButton(_:)))
            navigationItem.rightBarButtonItem = updateButton
        }
    }

    @objc private func touchRegisterItemButton(_ sender: UIBarButtonItem) {
        viewModel.validate(titleText: titleTextField.text, stockText: stockTextField.text,
                           currencyText: currencyTextField.text, priceText: priceTextField.text,
                           discountedPriceText: discountedPriceTextField.text, descriptionsText: descriptionsTextView.text)
    }

    @objc private func touchUpdateItemButton(_ sender: UIBarButtonItem) {
        viewModel.validate(titleText: titleTextField.text, stockText: stockTextField.text,
                           currencyText: currencyTextField.text, priceText: priceTextField.text,
                           discountedPriceText: discountedPriceTextField.text, descriptionsText: descriptionsTextView.text)
    }

    private func alertInputPassword() {
        let alertController: UIAlertController = .init(title: Style.Alert.InputPassword.title,
                                                message: Style.Alert.InputPassword.message,
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = Style.Alert.InputPassword.placeHolder
        }
        let register: UIAlertAction = .init(title: Style.Alert.Register.title, style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let password = alertController.textFields?[0].text else { return }
            switch self.mode {
            case .register:
                self.viewModel.registerItem(password: password)
            case .update:
                self.viewModel.updateItem(password: password)
            }
        }
        let cancel: UIAlertAction = .init(title: Style.Alert.Cancel.title, style: .default, handler: nil)
        alertController.addAction(register)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }

    private func alertDissatisfication() {
        let alertController: UIAlertController = .init(title: Style.Alert.Dissatisfication.title,
                                                message: Style.Alert.Dissatisfication.message, preferredStyle: .alert)
        let cancel: UIAlertAction = .init(title: Style.Alert.Cancel.title, style: .default, handler: nil)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: Set Keyboard associated Method
    private func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(moveDownKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }

    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else {
            return
        }
        let endFrame = endFrameValue.cgRectValue
        scrollViewBottomAnchor?.isActive = false
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -endFrame.height)
        scrollViewBottomAnchor?.isActive = true
        scrollView.contentInset.bottom = Style.DescriptionsTextView.spacingForKeyboard
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

    @objc private func moveDownKeyboard() {
        view.endEditing(true)
    }

    // MARK: Set Constraints Method
    private func configureConstraints() {
        configureBorderViewsConstraints()
        configureScrollViewConstraints()
        configurePhotoCollectionViewConstraints()
        configureInputViewsConstraints()
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
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionsTextView.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }

    private func configurePhotoCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: collectionViewBorderView.topAnchor,
                                                        constant: -Style.Views.verticalSpacing),
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
    }

    private func configureBorderViewsConstraints() {
        NSLayoutConstraint.activate([
            collectionViewBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                              constant: Style.Views.horizontalSpacing),
            collectionViewBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                               constant: -Style.Views.horizontalSpacing),
            collectionViewBorderView.bottomAnchor.constraint(equalTo: titleTextField.topAnchor,
                                                             constant: -Style.Views.verticalSpacing),
            titleBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                     constant: Style.Views.horizontalSpacing),
            titleBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                      constant: -Style.Views.horizontalSpacing),
            titleBorderView.bottomAnchor.constraint(equalTo: stockTextField.topAnchor, constant: -Style.Views.verticalSpacing),
            stockBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Style.Views.horizontalSpacing),
            stockBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                      constant: -Style.Views.horizontalSpacing),
            stockBorderView.bottomAnchor.constraint(equalTo: moneyStackView.topAnchor, constant: -Style.Views.verticalSpacing),
            priceBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Style.Views.horizontalSpacing),
            priceBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                      constant: -Style.Views.horizontalSpacing),
            priceBorderView.bottomAnchor.constraint(equalTo: descriptionsTextView.topAnchor,
                                                    constant: -Style.Views.verticalSpacing),
            collectionViewBorderView.heightAnchor.constraint(equalToConstant: Style.BorderView.height),
            titleBorderView.heightAnchor.constraint(equalToConstant: Style.BorderView.height),
            stockBorderView.heightAnchor.constraint(equalToConstant: Style.BorderView.height),
            priceBorderView.heightAnchor.constraint(equalToConstant: Style.BorderView.height)
        ])
    }

    private func configureInputViewsConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                    constant: Style.Views.horizontalSpacing),
            titleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                     constant: -Style.Views.horizontalSpacing),
            titleTextField.bottomAnchor.constraint(equalTo: titleBorderView.topAnchor,
                                                   constant: -Style.Views.verticalSpacing),
            stockTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                    constant: Style.Views.horizontalSpacing),
            stockTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                     constant: -Style.Views.horizontalSpacing),
            stockTextField.bottomAnchor.constraint(equalTo: stockBorderView.topAnchor,
                                                   constant: -Style.Views.verticalSpacing),
            currencyTextField.widthAnchor.constraint(equalToConstant: Style.CurrencyTextField.width),
            moneyStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                    constant: Style.Views.horizontalSpacing),
            moneyStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                     constant: -Style.Views.horizontalSpacing),
            moneyStackView.bottomAnchor.constraint(equalTo: priceBorderView.topAnchor,
                                                   constant: -Style.Views.verticalSpacing),
            descriptionsTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                          constant: Style.Views.horizontalSpacing),
            descriptionsTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                           constant: -Style.Views.horizontalSpacing),
            descriptionsTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

extension ItemEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Currency TextField - ToolBar(UIPickerView)
    private func configureCurrencyTextFieldToolBar() {
        let pickerView: UIPickerView = .init()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyTextField.inputView = pickerView
        let bar: UIToolbar = .init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.sizeToFit()
        bar.isUserInteractionEnabled = true
        let done: UIBarButtonItem = .init(title: Style.CurrenyPickerView.buttonTitle, style: .plain,
                                   target: self, action: #selector(touchDoneBarButtonItem(_:)))
        done.tintColor = Style.defaultTintColor
        let space: UIBarButtonItem = .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([space, done], animated: false)
        bar.sizeToFit()
        currencyTextField.inputAccessoryView = bar
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Style.CurrenyPickerView.numberOfRows
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.currencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = viewModel.currencies[row]
    }

    @objc private func touchDoneBarButtonItem(_ sender: UIBarButtonItem) {
        currencyTextField.resignFirstResponder()
    }
}

extension ItemEditViewController: UITextViewDelegate {
    // MARK: DescriptionTextView Delegate Method
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Style.DescriptionsTextView.placeHolderTextColor {
            textView.text = nil
            textView.textColor = Style.DescriptionsTextView.defaultTextColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Style.DescriptionsTextView.placeHolder
            textView.textColor = Style.DescriptionsTextView.placeHolderTextColor
        }
    }
}

extension ItemEditViewController: UICollectionViewDataSource {
    // MARK: PhotoCollectionView DataSource Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        if indexPath.item == .zero {
            guard let addPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionViewCell.identifier, for: indexPath) as? AddPhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            viewModel.delegate = addPhotoCell
            cell = addPhotoCell
        } else {
            guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemEditPhotoCollectionViewCell.identifier, for: indexPath) as? ItemEditPhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            photoCell.addDeleteButtonTarget(target: self, action: #selector(touchDeletePhotoButton(_:)), for: .touchUpInside)
            photoCell.bind(ItemEditPhotoCellViewModel(image: viewModel.images[indexPath.item-1]))
            photoCell.configureCell()
            cell = photoCell
        }
        return cell
    }

    @objc private func touchDeletePhotoButton(_ sender: UIButton) {
        for index in 0..<viewModel.images.count {
            let indexPath = IndexPath(item: index + 1, section: 0)
            guard let cell = photoCollectionView.cellForItem(at: indexPath) as? ItemEditPhotoCollectionViewCell else { continue }
            if cell.deleteButton === sender {
                viewModel.deleteImage(indexPath)
            }
        }
    }
}

extension ItemEditViewController: UICollectionViewDelegate {
    // MARK: PhotoCollectionView Delegate Method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == .zero {
            if viewModel.images.count >= Style.maximumImageCount {
                alertExcessImagesCount()
                return
            }
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    private func alertExcessImagesCount() {
        let alertController = UIAlertController(title: Style.Alert.ExcessImageCount.title,
                                                message: Style.Alert.ExcessImageCount.message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Style.Alert.Cancel.title, style: .default, handler: nil)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

extension ItemEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: UIImagePickerController Delegate Method
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
        return .init(width: collectionView.bounds.height * Style.PhotoCollectionView.cellSizeRatio,
                     height: collectionView.bounds.height * Style.PhotoCollectionView.cellSizeRatio)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Style.Views.verticalSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Style.PhotoCollectionView.edgeInsets
    }
}
