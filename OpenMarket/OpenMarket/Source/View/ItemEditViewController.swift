//
//  ItemEditViewController.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/08.
//

import UIKit

final class ItemEditViewController: UIViewController {
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
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.backgroundColor = Style.backgroundColor
        return scrollView
    }()
    private let photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.register(ItemPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemPhotoCollectionViewCell.identifier)
        collectionView.register(AddPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: AddPhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = Style.backgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceTextField, discountedPriceTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Style.verticalSpacing * 2
        return stackView
    }()
    private lazy var moneyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyTextField, priceStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Style.MoneyStackView.spacing
        return stackView
    }()

    // MARK: Properties
    private let mode: Mode
    private(set) var viewModel: ItemEditViewModel = .init()

    // MARK: Initializer
    init(mode: Mode) {
        self.mode = mode
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
        descriptionsTextView.text = Style.DescriptionsTextView.placeHolder
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
        discountedPriceTextField.keyboardType = .decimalPad
        stockTextField.keyboardType = .decimalPad
        priceTextField.keyboardType = .decimalPad
        currencyTextField.textAlignment = .center
        descriptionsTextView.textColor = Style.DescriptionsTextView.placeHolderTextColor
        descriptionsTextView.showsVerticalScrollIndicator = false
        descriptionsTextView.isScrollEnabled = false
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
            case .addPhoto(let indexPath):
                self?.photoCollectionView.insertItems(at: [indexPath])
            case .deletePhoto(let indexPath):
                self?.photoCollectionView.deleteItems(at: [indexPath])
            case .satisfied:
                self?.alertRegister()
            case .dissatisfied:
                self?.alertDissatisfication()
            default:
                break
            }
        }
    }

    private func configureNavigationBar() {
        let doneButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(touchRegisterItemButton(_:)))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc private func touchRegisterItemButton(_ sender: UIBarButtonItem) {
        viewModel.validate(title: titleTextField.text, stock: stockTextField.text,
                           currency: currencyTextField.text, price: priceTextField.text,
                           descriptions: descriptionsTextView.text)
    }

    private func alertRegister() {
        let alertController = UIAlertController(title: "비밀번호 입력", message: "등록자 인증을 위한 비밀번호이 필요합니다", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "비밀번호"
        }
        let register = UIAlertAction(title: "등록", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        alertController.addAction(register)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }

    private func alertDissatisfication() {
        let alertController = UIAlertController(title: "필수 요소 작성 불만족", message: "할인 가격을 제외한 모든 요소를 채워주세요", preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okay)
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
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionsTextView.bottomAnchor)
        ])
    }

    private func configurePhotoCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: collectionViewBorderView.topAnchor,
                                                        constant: -Style.verticalSpacing),
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }

    private func configureBorderViewsConstraints() {
        NSLayoutConstraint.activate([
            collectionViewBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                              constant: Style.horizontalSpacing),
            collectionViewBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                               constant: -Style.horizontalSpacing),
            collectionViewBorderView.bottomAnchor.constraint(equalTo: titleTextField.topAnchor,
                                                             constant: -Style.verticalSpacing),
            titleBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                     constant: Style.horizontalSpacing),
            titleBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                      constant: -Style.horizontalSpacing),
            titleBorderView.bottomAnchor.constraint(equalTo: stockTextField.topAnchor, constant: -Style.verticalSpacing),
            stockBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Style.horizontalSpacing),
            stockBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                      constant: -Style.horizontalSpacing),
            stockBorderView.bottomAnchor.constraint(equalTo: moneyStackView.topAnchor, constant: -Style.verticalSpacing),
            priceBorderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Style.horizontalSpacing),
            priceBorderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                      constant: -Style.horizontalSpacing),
            priceBorderView.bottomAnchor.constraint(equalTo: descriptionsTextView.topAnchor,
                                                    constant: -Style.verticalSpacing),
            collectionViewBorderView.heightAnchor.constraint(equalToConstant: Style.BorderView.height),
            titleBorderView.heightAnchor.constraint(equalToConstant: Style.BorderView.height),
            stockBorderView.heightAnchor.constraint(equalToConstant: Style.BorderView.height),
            priceBorderView.heightAnchor.constraint(equalToConstant: Style.BorderView.height)
        ])
    }

    private func configureInputViewsConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Style.horizontalSpacing),
            titleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                     constant: -Style.horizontalSpacing),
            titleTextField.bottomAnchor.constraint(equalTo: titleBorderView.topAnchor, constant: -Style.verticalSpacing),
            stockTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Style.horizontalSpacing),
            stockTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                     constant: -Style.horizontalSpacing),
            stockTextField.bottomAnchor.constraint(equalTo: stockBorderView.topAnchor, constant: -Style.verticalSpacing),
            currencyTextField.widthAnchor.constraint(equalToConstant: Style.CurrencyTextField.width),
            moneyStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Style.horizontalSpacing),
            moneyStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                     constant: -Style.horizontalSpacing),
            moneyStackView.bottomAnchor.constraint(equalTo: priceBorderView.topAnchor, constant: -Style.verticalSpacing),
            descriptionsTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                          constant: Style.horizontalSpacing),
            descriptionsTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                           constant: -Style.horizontalSpacing),
            descriptionsTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

extension ItemEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Currency TextField - ToolBar(UIPickerView)
    private func configureCurrencyTextFieldToolBar() {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyTextField.inputView = pickerView
        let bar = UIToolbar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.sizeToFit()
        bar.isUserInteractionEnabled = true
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(touchDoneBarButtonItem(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
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
    // MARK: PhotoCollectionView Delegate Method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            if viewModel.images.count >= 5 {
                alertExcessImagesCount()
                return
            }
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    private func alertExcessImagesCount() {
        let alertController = UIAlertController(title: "이미지 등록 개수 초과", message: "이미지는 최대 5개까지만 추가할 수 있습니다", preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okay)
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
        return Style.verticalSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Style.PhotoCollectionView.edgeInsets
    }
}

extension ItemEditViewController {
    enum Style {
        static let backgroundColor = UIColor.systemBackground
        static let defaultFont = UIFont.preferredFont(forTextStyle: .body)
        static let verticalSpacing: CGFloat = 20
        static let horizontalSpacing: CGFloat = 10
        enum PhotoCollectionView {
            static let cellSizeRatio: CGFloat = 3/4
            static let edgeInsets: UIEdgeInsets = .init(top: 20, left: 20, bottom: 0, right: 20)
        }
        enum TitleTextField {
            static let placeHolder = "제품명"
        }
        enum StockTextField {
            static let placeHolder = "제품 수량"
        }
        enum CurrencyTextField {
            static let placeHolder = "화폐"
            static let width: CGFloat = 80
        }
        enum PriceTextField {
            static let placeHolder = "제품 가격"
        }
        enum DiscountedPriceTextField {
            static let placeHolder = "할인 가격(선택 사항)"
        }
        enum DescriptionsTextView {
            static let placeHolder = "제품 설명을 입력하세요"
            static let placeHolderTextColor = UIColor.lightGray
            static let defaultTextColor = UIColor.black
            static let spacingForKeyboard: CGFloat = 30
        }
        enum MoneyStackView {
            static let spacing: CGFloat = 5
        }
        enum CurrenyPickerView {
            static let numberOfRows = 1
        }
        enum BorderView {
            static let backgroundColor = UIColor.systemGray4
            static let height: CGFloat = 1
        }
        enum TextField {
            static let tintColor = UIColor.clear
        }
    }
}
