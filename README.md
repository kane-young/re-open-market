# Open Market App

> 마켓 상품의 정보를 제공하는 API를 이용해서 당근마켓 앱과 같이 사용자가 직접 상품을 편집할 수 있는 기능을 제공하는 앱입니다



<img src="https://user-images.githubusercontent.com/64566207/139567580-ccfb4bf8-4896-4afc-8c3c-8d02ff60dc7e.png" width="250">

**Index**

- 기능
- 설계 및 구현
- trouble shooting
- 학습한 내용

---



<p float="left">
  <img src="https://user-images.githubusercontent.com/64566207/139628401-2ee53997-f938-4dbf-8ecd-d9a2dee4b8f0.gif" width="250" />
  <img src="https://user-images.githubusercontent.com/64566207/139628398-e9870693-b2a7-4cb4-a8e4-ae8f097e9331.gif" width="250" /> 
  <img src="https://user-images.githubusercontent.com/64566207/139628375-8b2ea94a-c751-49c5-82ee-b5a8160efd8d.gif" width="250" />
</p>

<br>

## 기능

- 마켓 상품 리스트
- 마켓 상품 세부정보
- 마켓 상품 등록
- 마켓 상품 수정
- 마켓 상품 삭제

<br>

### 마켓 상품 리스트

상품 정보 리스트를 무한 스크롤을 통해서 볼 수 있으며, 네비게이션 바에 위치한 스위치를 통해서 리스트를 보여주는 Cell Layout을 변경할 수 있습니다

<img src="https://user-images.githubusercontent.com/64566207/139630694-42392730-573d-45a9-a620-44fdde7c0576.gif" width="250"/>



### 마켓 상품 세부정보

해당 상품에 대한 상품명, 가격, 재고수량, 이미지, 세부 설명 정보를 제공하며, 필요에 따라 삭제 및 수정을 할 수 있게 합니다

<img src="https://user-images.githubusercontent.com/64566207/139631032-6c05204f-3922-435e-b8fc-97b3f227075c.gif" width="250" />

### 마켓 상품 등록

양식에 맞는 정보를 입력 후 등록을 하면 해당 상품을 마켓에 등록하게 됩니다

<img src="https://user-images.githubusercontent.com/64566207/139632154-73b2a2f0-175d-4fcd-952d-3fc04d5fcd4c.gif" width="250"/>

### 마켓 상품 수정

양식에 맞는 정보를 입력 후, 등록시에 입력했던 비밀번호를 통해 상품 수정

<img src="https://user-images.githubusercontent.com/64566207/139633136-710aac7d-9833-4a42-a6aa-9de8f30bdc29.gif" width="250"/>

### 마켓 상품 삭제

등록시 입력했던 비밀번호를 통해서 상품 삭제

<img src="https://user-images.githubusercontent.com/64566207/139999964-249f8fe6-793e-425c-8b5e-076c23b66ebd.gif" width="250"/>

<br>

---



## 설계 및 구현

### ViewController 구성

<img src="https://user-images.githubusercontent.com/64566207/139639565-049e26e1-1b1d-420d-bdc4-428a5ea8b943.png" width="800"/>

<br>

### MVVM 구조

View와 Model을 서로 독립시키며, ViewModel에 대한 Unit Test를 진행하기 위해서 MVVM을 채택하였습니다.

또한 프로토콜을 통한 추상화를 통해서 의존성 역전시켜, 의존성 주입을 통해 외부 의존성과 무관한 테스트를 진행하였습니다

![스크린샷 2021-11-01 오후 8 44 11](https://user-images.githubusercontent.com/64566207/139666697-52e57762-95e8-4b9c-b3fd-8f1b6f31abae.png)

-  각 View와 View Model 공통 구현 사항
  - 각 View Model은 State 타입을 가지고 있으며, Instance stored property로 State를 가지고 있다
  - View Model은 `bind(_ handler: (state) -> Void)` 메서드를 통해 `handler` 를 등록하며, ViewModel의 `state` 가 변경될 때마다 Property Observer를 통해서 해당 `handler` 를 동작시킨다.

<br>

<br>

### 타입 역할 분배

**Model - Network**

| struct / protocol / enum              | 역할                                                         |
| ------------------------------------- | ------------------------------------------------------------ |
| `NetworkManager/NetworkManagable`     | - URLSession을 통한 http 통신을 진행하고, 이에 대한 response, Error를 처리 |
| `RequestMaker/RequestMakable`         | - httpMethod와 조건에 맞는 request를 생성                    |
| `MultiPartForm/MultiPartFormProtocol` | - multipart/form-data 형식의 request를 제공하고자 multipart/form-data 형식에 맞는 Data 인코딩 |
| `HttpMethod`                          | - get, post, patch, delete와 같은 HttpMethod                 |
| `OpenMarketAPI`                       | - 해당 앱에서 사용되는 API의 각 요청에 대한 URL, path 제공   |
| `MimeType`                            | - application/json, image/jpeg 와 같은 MimeType              |
| `NetworkError`                        | - Networking 과정에 일어날 수 있는 각 Error 타입에 대한 정의 |

**Model - Dtat Transfer Object(DTO)**

| struct     | 역할                                                         |
| ---------- | ------------------------------------------------------------ |
| `Item`     | - 서버로부터 받아온 마켓 Data를 Json Decoding 하기 위해 정의한 타입 |
| `ItemList` | - 서버로부터 받아온 마켓 리스트 Data를 Json Decoding 하기 위해 정의한 타입 |

<br>

<br>

**View - ViewController / Components**

| class / protocol                    | 역할                                                         |
| ----------------------------------- | ------------------------------------------------------------ |
| `ItemListViewController`            | - 서버로부터 받아온 마켓 상품의 목록을 View를 통해 출력<br />- 상품 생성 버튼 제공 |
| `ItemCellDisplayable`               | - `ItemListCollectionViewCell` 과 `ItemGridCollectionViewCell` 을 추상화 시키기 위해 정의 |
| `ItemListCollectionViewCell`        | - `ItemListViewController` 에 있는 `CollectionView` List Type 정의 |
| `ItemGridCollectionViewCell`        | - `ItemListViewController` 에 위치한 `CollectionView` Grid Type 정의 |
| `ItemDetailViewController`          | - 마켓 상품의 상세 정보 제공<br />- 제목, 가격, 할인 가격, 재고, 상세 설명, 이미지<br />- `ItemDetailViewControllerDelegate` 를 통해 상품이 수정되었을 경우 다른 객체에 해당 이벤트를 전달 |
| `ItemDetailPhotoCollectionViewCell` | - 마켓 상품 상세 정보 중 이미지를 출력하기 위한 `CollectionView` Cell 정의 |
| `ItemEditViewController`            | - 마켓 상품 생성, 수정 양식 제공<br />- `ItemEditViewControllerDelegate` 를 통해 상품이 편집되었을 경우 다른 객체에 해당 이벤트를 전달 |
| `ItemEditPhotoCollectionViewCell`   | - `ItemEditViewController` 에서 상품 이미지를 선택하는 `CollectionView`에서 사용되는 Cell 정의 |
| `AddPhotoCollectionViewCell`        | - `ItemEditViewController` 에서 상품 이미지 추가 버튼을 제공하는 Cell 정의 |

<br>

<br>

**ViewModel - ViewModel / UseCase**

| class / protocol         | 역할                                                         |
| ------------------------ | ------------------------------------------------------------ |
| `ItemListViewModel`      | - `ItemListNetworkUseCase` 를 통해서 마켓 상품 리스트를 가져온다 |
| `ItemListCellViewModel`  | - `ItemListViewModel` 에 위치한 마켓 상품들 중 해당 Cell의 indexPath 에 위치한 `Item` 을 출력하기 위해서 `ImageNetworkUseCase` 를 통해 Thumbnail을 서버로부터 받아오고, Cell에 표시할 정보를 가공한다 |
| `ItemDetailViewModel`    | - `ItemNetworkUseCase` 를 통해서 마켓 상품 상세 정보를 가져오며, 삭제 요청에 대한 Command 패턴 메서드를 제공한다<br />- `ItemNetworkUseCase` 를 통해 가져온 상세 정보 중 이미지 정보를 `ImageNetworkUseCase` 를 통해서 가져오며, `ItemDetailViewController` 의 View에 사용할 정보를 가공한다 |
| `ItemEditViewModel`      | - `ItemEditNetworkUseCase` 를 통해서 마켓 상품 상세 정보를 가져오며, 수정, 생성 요청에 대한 Command 패턴 메서드를 제공한다<br />- `ItemEditNetworkUseCase` 를 통해 가져온 상세 정보 중 이미지 정보를 `ImageNetworkUseCase` 를 통해서 가져오며, `ItemEditViewController` 의 View에 사용할 정보를 가공한다 |
| `PhotoCellViewModel`     | - `ItemDetailPhotoCollectionViewCell`, `ItemEditPhotoCollectionViewCell` 의 View에 사용할 정보를 제공한다 |
| `ItemListNetworkUseCase` | - `NetworkManager` 를 통해서 마켓 상품 리스트를 페이지 순서대로 fetch 해준다<br />- DTO `ItemList` 를 통해서 네트워킹으로 획득한 Data를 디코딩<br />- `Pagination` 처리 되어 있는 API 이므로 `isLoading` 변수를 통해서 페이지당 한 번만 request할 수 있도록 구현하였다 |
| `ImageNetworkUseCase`    | - `NSCache` 을 통해서 메모리 캐싱을 구현하였으며, url을 key값으로 지정하여 캐싱이 되어 있을 경우에는 Networking 을 하지 않고 캐싱 정보를 통해서 빠르게 View에 나타낼 수 있도록 구현<br />- `NSCache` 를 private 접근 제한자로 프로퍼티 인스턴스로 가지고 있으므로, `ImageNetworkUseCase` 를 `shared` 타입 객체로 하나 생성하여, 프로젝트 전체에서 이미지에 대한 메모리 캐싱을 사용할 수 있도록 구현 |
| `ItemNetworkUseCase`     | - `NetworkManager` 를 통해서 마켓 상품에 대한 `get`, `delete` 메서드를 수행할 수 있도록 함<br />- DTO `Item` 를 통해서 네트워킹으로 획득한 Data를 디코딩 |
| `ItemEditNetworkUseCase` | - `NetworkManager` 를 통해서 마켓 상품에 대한 `post`, `patch` 메서드를 수행할 수 있도록 함<br />- DTO `Item` 를 통해서 네트워킹으로 획득한 Data를 디코딩 |

<br>

### View객체들 간에 이벤트 주고 받기 - Delegate, Notification

View가 사용자로부터 이벤트가 발생할 경우 다른 View 또한 해당 이벤트에 대해 반응하기 위해 Delegate 혹은 Notification, KVO가 필요하다

<img src="https://user-images.githubusercontent.com/64566207/140001869-69a7f015-c167-4c1d-aea9-9e05f0ebe45a.png" width="550">

<img src="https://user-images.githubusercontent.com/64566207/140001772-21d3492b-ced8-4041-926f-376daa4d350d.png" width="550">

<img src="https://user-images.githubusercontent.com/64566207/140001778-9f264fbf-2296-4586-82ea-e6fcb74e7a06.png" width="550">

<img src="https://user-images.githubusercontent.com/64566207/140001769-b06566d0-3617-45f5-9646-dfc67cffd770.png" width="800">

<br>

## 기능

### 마켓 상품 리스트

**상품 조회화면 Network Request 과정**

![마켓상품리스트](https://user-images.githubusercontent.com/64566207/140022202-377de509-e182-4d35-b990-fba20196b8da.png)

**Cell Layout 변경**

`UISegmentedControl` 의 값이 변경될 때 아래 method가 수행되도록 하였다. `Cell` size를 바뀌더라도 현재 보고 있는 상품을 볼 수 있도록  `collectionView(_:willDisplay:forItemAt:)` 메서드에서 `currentPosition` 을 지정하여 해당 위치로 스크롤 시켰다

```swift
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
  guard let currentPosition = currentPosition else { return }
  collectionView.scrollToItem(at: currentPosition, at: .centeredVertically, animated: false)
}
```

```swift
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
  switch cellStyle {
    case .list:
    return .init(width: collectionView.bounds.width * Style.Cell.listWidthRatio,
                 height: collectionView.bounds.height * Style.Cell.listHeightRatio)
    case .grid:
    return .init(width: collectionView.bounds.width * Style.Cell.gridWidthRatio +
                 Style.Cell.gridWidthConstant,
                 height: collectionView.bounds.height * Style.Cell.gridHeightRatio + 
                 Style.Cell.gridHeightConstant)
  }
}
```

```swift
func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                    forItemAt indexPath: IndexPath) {
  switch cellStyle {
    case .list:
    currentPosition = IndexPath(item: indexPath.item - 3, section: .zero)
    case .grid:
    currentPosition = IndexPath(item: indexPath.item - 2, section: .zero)
  }
  //...
}
```

<br>

**Infinite Scrolling**

해당 마켓 상품 리스트의 경우, Pagining 처리가 되어 있기 때문에, 아래 방향 스크롤을 통해 자동으로 다음 페이지 상품 리스트를 load 하도록 구현하였다. 해당 구현은 `collectionView(_:willDisplay:forItemAt:)` 에서 하였으며, `ItemListNetworkUseCase` 에서 request 성공시 page 값을 `+1` 씩 올리며, 중복 request를 하지 않기 위해 `isLoading: Bool` 변수를 활용하였다

```swift
func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                    forItemAt indexPath: IndexPath) {
  //...
  if viewModel.items.count <= indexPath.item + Style.CollectionView.remainCellCount {
    viewModel.loadItems()
  }
}
```

```swift
final class ItemListNetworkUseCase: ItemListNetworkUseCaseProtocol {
  private let networkManager: NetworkManagable
  private var page: Int = 1
	private var isLoading: Bool = false
 
  func retrieveItems(completionHandler: @escaping (Result<[Item], ItemListNetworkUseCaseError>) -> Void) {
    //...
    if isLoading {
       return
    }
    isLoading = true
    networkManager.request(urlString: urlString, with: nil, httpMethod: .get) { [weak self] result in
        				//...
                self?.page = itemList.page + 1
                return .success(itemList.items)
              } catch {
                return .failure(ItemListNetworkUseCaseError.decodingError)
              }
          }
        completionHandler(result)
        self?.isLoading = false
  }
}
```

<br>

**마켓 상품 목록 업데이트**

`UIActivityIndicator` 의 애니메이션을 활성화 시켜 loading 중임을 사용자에게 명시하며, `ItemListViewModel` 내의 `items` 배열을 비우고 다시 load함으로써 업데이트를 진행한다

```swift
@objc private func refreshItemList(_ sender: UIBarButtonItem) {
  activityIndicator.startAnimating()
  viewModel.reset()
}
//ItemListViewController
```

```swift
func reset() {
  items.removeAll()
  useCase.reset()
  loadItems()
}
//ItemListViewModel
```

<br>

### 마켓 상품 세부정보

**상품 세부정보 Network Request 과정**

![마켓상품세부정보](https://user-images.githubusercontent.com/64566207/140025849-e9df7702-ec5b-4524-b4ee-85864fb789f9.png)

<br>

**상품 이미지 Pagining**

- `UICollectionView`의 `isPagingEnabled` 를 통해 페이지를 넘기듯이 다음 cell로 넘어갈 수 있도록 설정

- scroll시 `scrollViewsDidScroll(_: UIScrollView)` 를 통해 pageControl 이 변경되도록 구현

```swift
private let collectionView: UICollectionView = {
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
  collectionView.isPagingEnabled = true
	//...
}()
private let pageControl: UIPageControl = {
  let pageControl: UIPageControl = .init()
  //..
  return pageControl
}()

func scrollViewDidScroll(_ scrollView: UIScrollView) {
  let scrollPos = scrollView.contentOffset.x / view.safeAreaLayoutGuide.layoutFrame.width
  pageControl.currentPage = Int(scrollPos)
}
```

<br>

**상품 세부 정보 업데이트**

상품 편집 이후에 편집된 정보를 확인하기 위해서 상품 정보를 다시 load 한다. 해당 과정은 `ItemEditViewControllerDelegate` 메서드 내에서 구현한다. 해당 메서드는 편집이 성공되었을 경우 `ItemEditViewController` 에서 수행된다

- 상품 수정 이후 바로 서버로 해당 상품 정보를 요청할 경우 `403 Forbidden Error` 가 발생한다. `DispatchQueue.main.asyncAfter(deadline: .now() + 1)`을 통해서 해당 작업을 지연시켜주었습니다

```swift
extension ItemDetailViewController: ItemEditViewControllerDelegate {
    // MARK: Item Edit View Controller Delegate Method
    func didSuccessEdit(item: Item) {
        isUpdated = true
        viewModel.reset()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.viewModel.loadItem()
        }
    }
}
```

<br>

**상품 제거 요청**

- `UIAlertController` 의 `UITextField` 를 통해서 Password를 입력받고, `DeleteItem` 을 요청한다.

- 제거 요청이 성공하면, `delegate?.itemStateDidChanged()` 를 통해서 다른 View에게 해당 이벤트가 발생했음을 알린다

```swift
private func alertCheckPassword() {
    let alertController: UIAlertController = .init(title: Style.Alert.InputPassword.title,
                                            message: Style.Alert.InputPassword.message,
                                            preferredStyle: .alert)
    alertController.addTextField { textField in
        textField.placeholder = Style.Alert.InputPassword.placeHolder
        textField.isSecureTextEntry = true
    }
    let register: UIAlertAction = .init(title: Style.Alert.Action.deleteTitle, style: .destructive) { [weak self] _ in
        guard let self = self else { return }
        guard let password = alertController.textFields?[0].text else { return }
        self.viewModel.deleteItem(password: password)
    }
    let cancel: UIAlertAction = .init(title: Style.Alert.Action.cancelTitle, style: .default, handler: nil)
    alertController.addAction(register)
    alertController.addAction(cancel)
    present(alertController, animated: true, completion: nil)
}

private func alertSuccessDeleteItem() {
    let alertController: UIAlertController = .init(title: Style.Alert.DeleteItem.title,
                                                       message: Style.Alert.DeleteItem.message, preferredStyle: .alert)
    let okay: UIAlertAction = .init(title: Style.Alert.Action.okayTitle, style: .default) { [weak self] _ in
       self?.delegate?.itemStateDidChanged()
       self?.navigationController?.popViewController(animated: true)
    }
    alertController.addAction(okay)
    present(alertController, animated: true, completion: nil)
}
```



### 마켓 상품 생성 및 수정

**마켓 상품 생성 Network Request 과정**

![스크린샷 2021-11-03 오후 7 41 10](https://user-images.githubusercontent.com/64566207/140046409-31d34d5a-b6e6-46da-9586-5ab85b117186.png)

**마켓 상품 생성 Network Request 과정**

![마켓상품생성NetworkRequest과정](https://user-images.githubusercontent.com/64566207/140050182-658d25fe-e400-4374-b64b-737ede9e09d6.png)



**Keyboard Frame으로 보이지 않게될 View를 위한 AutoLayout 변경**

```swift
@objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
    let endFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else {
        return
    }
    let endFrame = endFrameValue.cgRectValue
    scrollViewBottomAnchor?.isActive = false
    scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                constant: -endFrame.height)
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
```

<br>

**이미지 등록을 위한 이미지 선택**

- 선택한 Cell이 `AddPhotoCollectionViewCell` 일 경우, `UIImagePickerController`을 `present()`
- 선택 가능한 Image의 개수는 5개 이므로, 조건문을 통해서 개수 관리
- `UIImagePickerController` 를 통해서 Image 를 선택할 경우  ViewModel의 `[UIImage]` 배열에 추가
- `[UIImage]` 배열에 `UIImage` 추가시 해당 `IndexPath` 전달, `UICollectionView` 에서 해당 `IndexPath` 추가 수행
- 첫 번째 `AddPhotoCollectionViewCell` 에서 현재 등록된 이미지 개수를 나타내는 Text 변경하기 위해서  `Notification` 발송

```swift
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
```

```swift
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
```

```swift
viewModel.bind { [weak self] state in
    switch state {
    case .addPhoto(let indexPath):
        self?.photoCollectionView.insertItems(at: [indexPath])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addPhoto"), object: nil)
    case .deletePhoto(let indexPath):
        self?.photoCollectionView.deleteItems(at: [indexPath])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deletePhoto"), object: nil)
    	//...
}
```

<br>

**UITextView PlaceHolder 제공**

`UITextField`와 다르게  `UITextView`의 경우 PlaceHolder를 제공하지 않는 다는 점에서 직접 구현이 필요하다. 해당 `ItemEditViewController` 의 경우, 상품의 상세 설명을 기입하는 InputView만 `UITextView` 를 활용하기 때문에, 직접 `ItemEditViewController` 에서 `UITextViewDelegate` 를 채택하여서 PlaceHolder를 구현함

```swift
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
```

