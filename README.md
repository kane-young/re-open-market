# Open Market v1.0

오픈 마켓 앱은 사용자가 직접 상품을 생성, 수정, 삭제할 수 있는 앱으로, REST API를 통해 서버와 통신을 합니다.


<img src="https://user-images.githubusercontent.com/64566207/139567580-ccfb4bf8-4896-4afc-8c3c-8d02ff60dc7e.png" width="250">



Available

- iPhone, iPad 지원
- 화면의 경우 세로 모드 전용

Index

- [기능](#기능)
- [설계 및 구현](#설계-및-구현)
- [Unit Test](#Unit-Test)
- [Trouble Shooting](#Trouble-Shooting)
- [개선 요구사항](#개선-요구사항)

<br>

## 기능

<table style="width:100%">
  <tr>
	<th>마켓 상품 리스트</th> 
    <th>마켓 상품 세부정보</th>
    <th>마켓 상품 등록</th> 
  </tr>
  <tr>
  	<td><img width="268" src="https://user-images.githubusercontent.com/64566207/139630694-42392730-573d-45a9-a620-44fdde7c0576.gif"></img></td>
    <td><img width="268" src="https://user-images.githubusercontent.com/64566207/139631032-6c05204f-3922-435e-b8fc-97b3f227075c.gif"></img></td>
    <td><img width="268" src="https://user-images.githubusercontent.com/64566207/139632154-73b2a2f0-175d-4fcd-952d-3fc04d5fcd4c.gif"></img></td> 
  </tr>
</table>

<table style="width:100%">
  <tr>
	<th>마켓 상품 수정</th> 
    <th>마켓 상품 삭제</th>
  </tr>
  <tr>
  	<td><img width="268" src="https://user-images.githubusercontent.com/64566207/139633136-710aac7d-9833-4a42-a6aa-9de8f30bdc29.gif"></img></td>
    <td><img width="268" src="https://user-images.githubusercontent.com/64566207/139999964-249f8fe6-793e-425c-8b5e-076c23b66ebd.gif"></img></td>
    <td><img width="268" height="0" src="https://user-images.githubusercontent.com/64566207/141391969-53047486-1dae-461e-8838-33433e80a10c.png"></img></td> 
  </tr>
</table>

---

## 설계 및 구현

Index
- [ViewController 간의 전환 흐름](#ViewController-간의-전환-흐름)
- [MVVM 구조](#MVVM-구조)
- [View객체들 간에 이벤트 주고 받기 - Delegate, NotificationCenter](#View객체들-간에-이벤트-주고-받기---Delegate,-NotificationCenter)
- [ItemListViewController 구현](#ItemListViewController-구현)
- [ItemDetailViewController 구현](#ItemDetailViewController-구현)
- [ItemEditViewController 구현](#ItemEditViewController-구현)

<br>

### ViewController 간의 전환 흐름

<img src="https://user-images.githubusercontent.com/64566207/141394762-4e50164e-59d7-4634-945a-437b5c792bb2.png" width="800"/>

<br>

### MVVM 구조

![스크린샷 2021-11-01 오후 8 44 11](https://user-images.githubusercontent.com/64566207/139666697-52e57762-95e8-4b9c-b3fd-8f1b6f31abae.png)

MVVM 채택 이유

- 해당 프로젝트는 이전 협업으로 진행하였던 [OpenMarket](https://github.com/kane-young/open-market) 프로젝트를 새롭게 진행한 re-project 입니다.
이전 프로젝트를 진행하면서 `Massive ViewController` 의 단점과 View를 통해 출력될 Data에 대한 테스트가 불가능하다는 단점을 느껴, 이번 프로젝트는 `MVVM` 디자인 패턴을 사용하게 되었습니다


각 View와 View Model 공통 구현 사항
  - 각 View Model은 State 타입을 가지고 있으며, Instance stored property로 State를 가지고 있다
  - View Model은 `bind(_ handler: (state) -> Void)` 메서드를 통해 `handler` 를 등록하며, ViewModel의 `state` 가 변경될 때마다 Property Observer를 통해서 해당 `handler` 를 동작시킨다.


<br>
<br>

### View객체들 간에 이벤트 주고 받기 - Delegate, NotificationCenter

View가 사용자로부터 이벤트가 발생할 경우 다른 View 또한 해당 이벤트에 대해 반응하기 위해 Delegate 혹은 NotificationCenter가 필요하다

<img src="https://user-images.githubusercontent.com/64566207/140001869-69a7f015-c167-4c1d-aea9-9e05f0ebe45a.png" width="550">

Photo 갯수 변경시 `AddPhotoCollectionViewCell`에 반영해주기 위해서 `NotificationCenter` 사용

<br>

<img src="https://user-images.githubusercontent.com/64566207/140001772-21d3492b-ced8-4041-926f-376daa4d350d.png" width="550">

`ItemEditViewController` 에서 상품 수정시 `ItemDetailViewController` 에서 변경사항을 반영하기 위해 Delegate 패턴 활용

<br>

<img src="https://user-images.githubusercontent.com/64566207/140001778-9f264fbf-2296-4586-82ea-e6fcb74e7a06.png" width="550">

`ItemDetailViewController` 에서 상품 삭제시 `ItemListViewController` 에서 변경사항을 반영하기 위해 Delegate 패턴 활용

<br>

<img src="https://user-images.githubusercontent.com/64566207/140001769-b06566d0-3617-45f5-9646-dfc67cffd770.png" width="800">

`ItemEditViewController` 에서 상품 생성시 `ItemListViewController` 에서 생성된 상품을 `ItemDetailViewController` 로 띄우기 위해 Delegate 패턴 활용

<br>

---

### ItemListViewController 구현

**상품 조회화면 Network Request 과정**

![마켓상품리스트](https://user-images.githubusercontent.com/64566207/140022202-377de509-e182-4d35-b990-fba20196b8da.png)

**Cell Layout 변경**

`UISegmentedControl` 의 값이 변경될 때 `cellStyle` 프로퍼티 값을 변경

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


`Cell` size가 바뀌더라도 현재 보고 있는 상품을 볼 수 있도록, `collectionView(_:willDisplay:forItemAt:)` 메서드에서 `currentPosition` 을 지정하고, 해당 위치로 스크롤


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

<img src="https://user-images.githubusercontent.com/64566207/141038244-fc89e264-60e2-40b3-9d1a-30da78248663.png" width="550">

<br>

**Infinite Scrolling**

해당 마켓 상품 리스트의 경우, 사용자의 편의성을 고려하여
아래 방향 스크롤을 통해 자동으로 다음 페이지 상품 리스트를 load 하도록 구현하였습니다.
해당 구현은 `collectionView(_:willDisplay:forItemAt:)` 잔여 상품갯수를 비교하여 요청하였습니다.
`ItemListNetworkUseCase` 에서 request 성공시 page 값을 `+1` 씩 올리며,
 중복 request를 하지 않기 위해 `isLoading: Bool` 변수를 활용하였다

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
<img src="https://user-images.githubusercontent.com/64566207/141039839-de437143-92d8-4e92-8ffa-9ad2ad6c6dd0.png" width="550">

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

---

### ItemDetailViewController 구현

**상품 세부정보 Networking**

<img src="https://user-images.githubusercontent.com/64566207/140025849-e9df7702-ec5b-4524-b4ee-85864fb789f9.png" width="800">

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
<img src="https://user-images.githubusercontent.com/64566207/141040674-12acdefb-b913-4dc2-9698-722fa66c8021.png" width="550">

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

<br>

---
### ItemEditViewController 구현

**마켓 상품 생성 Networking**

<img src="https://user-images.githubusercontent.com/64566207/140046409-31d34d5a-b6e6-46da-9586-5ab85b117186.png" width="550">

<br>

**마켓 상품 수정 Networking**

<img src="https://user-images.githubusercontent.com/64566207/140050182-658d25fe-e400-4374-b64b-737ede9e09d6.png" width="800">

<br>

**Keyboard Frame으로 보이지 않게될 View를 위한 AutoLayout 변경**
 
 키보드가 올라올 때 혹은 사라질 때 Post되는 `UIResponder.keyboardWillHideNotification`, `UIResponder.keyboardWillShowNotification`를 활용해서 AutoLayout Constraint 값을 변경

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
<img src="https://user-images.githubusercontent.com/64566207/141041299-76279d66-d67a-438d-b993-9d058d770b14.png" width="550">

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

<br>

---
## Unit Test

### Unit Test를 진행한 이유

가장 큰 이유는 작성한 코드가 제대로 작동하는지에 대한 검증이며, 요구사항 변경이나 리팩토링과 같은 코드 수정 과정에서 더 유연하고 안정적인 대응을 할 수 있기 때문입니다. 또한 부수적으로 테스트 코드를 작성하는 과정에서 자연스럽게 코드의 모듈화를 고민하게 되는 등의 이점을 가지고 올 수 있다고 생각되어 테스트를 진행하였습니다.

<br>

### Unit Test 진행

Model의 `NetworkManager` 와 같은 Network 관련 로직, 그리고  `ViewModel`, `UseCase` 를 중심으로 테스트를 진행하였습니다. `NetworkManager` 와 `ViewModel`, `UseCase` 타입들의 경우 타 타입에 대한 의존성이 있기 때문에 Mock, Stub와 같은 Test Doubles를 사용하여 의존성을 주입하고 테스트를 진행하였습니다. 총 24개 타입에 대한 64개의 테스트 명세를 작성하였으며, `given`, `when`, `then` 패턴을 통해서 테스트 명세의 가독성을 높였습니다

<img src="https://user-images.githubusercontent.com/64566207/140265227-32e0c62c-d3a5-4343-9cd0-c3865a83b978.png" width="300">

<br>

### 네트워크에 외존하지 않는 테스트

이번 프로젝트에서 대표적으로 소개하고자 하는 테스트는 `MockURLProtocol` 을 통한 `NetworkManager` 테스트 입니다. `URLSession` 을 통해서 네트워크 관련 로직을 테스트할 경우, 네트워크 연결 혹은 서버 구축 여부에 따라 테스트가 항상 같은 결과를 도출하지 못할 수 있습니다. 따라서 이런 외부 의존성을 주입하기 위해서  `MockURLProtocol` 을 작성하였습니다.

```swift
func test_when_아이템수정시_then_statusCode가200번대가아닐경우_then_invalidResponse에러발생() {
    //given
    let expectedError: NetworkError = .invalidResponseStatuscode(404)
    guard let path = OpenMarketAPI.patchProduct(id: 10).path else {
        XCTFail()
        return
    }
    MockURLProtocol.requestHandler = { _ in
        let response = HTTPURLResponse(url: path, statusCode: 404, httpVersion: nil, headerFields: nil)
        return (response, nil, nil)
    }
    //when
    networkManager.request(urlString: OpenMarketAPI.patchProduct(id: 10).urlString,
                           with: Dummy.patchItem, httpMethod: .patch) { [weak self] result in
        switch result {
        case .success(_):
            XCTFail()
        case .failure(let error):
            //then
            XCTAssertEqual(error, expectedError)
            self?.expectation.fulfill()
        }
    }
    wait(for: [expectation], timeout: 2.0)
}
```
<br>

---

## Trouble Shooting
- [Cachimg 된 이미지가 출력되지 않는 Bug](#Caching-된-이미지가-출력되지-않는-Bug)
- [ItemEditPhotoCollectionViewCell 의 DeleteButton Bug](#ItemEditPhotoCollectionViewCell-의-DeleteButton-Bug)
- [Item 정보를 load한 후, Response Data 중 images들을 load 받는 중 Bug 발생](#Item-정보를-load한-후,-Response-Data-중-images들을-load-받는-중-Bug-발생)
- [각 Device Size 별 혹은 회전에 따른 AutoLayout Bug](#각-Device-Size-별-혹은-회전에-따른-AutoLayout-Bug)
- [iPad - Alert(Action Sheet) 관련 이슈](#iPad---Alert(Action-Sheet)-관련-이슈)
- [ItemListViewController - Refresh시 Item 배열에 대한 런타임 에러](ItemListViewController---Refresh시-Item-배열에-대한-런타임-에러)

<br>

### Caching 된 이미지가 출력되지 않는 Bug [(관련 Issue)](https://github.com/kane-young/re-open-market/issues/1)

**문제 진단**

- 초기 Networking을 통해서 View에 보여지는 Image의 경우는 제대로 출력이 되지만, Caching 된 이미지의 경우 출력이 되지 않는 것을 발견
- `ImageNetworkUseCase` 의 Caching 사용 코드에서 BreakPoint 설정
- BreakPoint로 부터 `UIImage` 값의 흐름 파악, `retrieveImage()` 메서드 내, `guard case var .update(metaData) = self?.state else { return }` 에서 빠른 종료됨을 파악

**해결 방법**

- `configureCell()` 에서 초기 Networking 이미지가 제대로 출력되어진 것은 Networking 부하로 인해 먼저 `retrieveImage()` 를 수행하더라도 `updateText()` 가 끝난시점에 `retrieveImage()` 의`switch` 구문이 수행되기 때문이다
- 의도적으로 `retrieveImage()` 와 `updateText()` 의 순서를 변경하면, 해당 `guard` 구문에서  return이 발생하지 않게 된다

```swift
func configureCell() {
    retrieveImage()
    updateText()
}//cell metaData를 변경하고 state 값을 변경하는 함수

private func retrieveImage() {
    guard let urlString = marketItem.thumbnails.first else {
        state = .error(.emptyPath)
        return
    }
    imageTask = useCase.retrieveImage(with: urlString, completionHandler: { [weak self] result in
        switch result {
        case .success(let image):
            guard case var .update(metaData) = self?.state else { return }
            metaData.image = image
            self?.state = .update(metaData)
        case .failure(let error):
            self?.state = .error(.useCaseError(error))
        }
    })
}//이미지 관련 로직을 가지고 있는 useCase로 부터 image를 받아오는 함수

private func updateText() {
    let isneededDiscountedLabel = marketItem.discountedPrice == nil
    let discountedPrice = discountedPriceText(isneededDiscountedLabel)
    let originalPrice = originalPriceText(isneededDiscountedLabel)
    let stockLabelTextColor: UIColor = marketItem.stock == 0 ? .systemYellow : .black
    let stock = stockText(marketItem.stock)
    let metaData = MetaData(image: nil,
                            title: marketItem.title,
                            isneededDiscountedLabel: isneededDiscountedLabel,
                            discountedPrice: discountedPrice,
                            originalPrice: originalPrice,
                            stockLabelTextColor: stockLabelTextColor,
                            stock: stock)
    state = .update(metaData)
}//init을 통해서 주입받은 marketItem을 통해서 image를 제외한 metaData를 채우는 함수
```

<br>

### ItemEditPhotoCollectionViewCell 의 DeleteButton Bug [(관련 Issue)](https://github.com/kane-young/re-open-market/issues/14)

**문제 진단**

- 앞쪽에 위치한 Cell의 경우 문제 없이 `DeleteButton` 작동을 확인, 뒤쪽 Cell의 경우 작동되지 않음을 확인
- Cell이 Reuse 되면서 문제 발생했음을 판단, `DeleteButton` `touchUpInside` target action 메서드 내부에  BreakPoint 설정

```swift
@objc private func touchDeletePhotoButton(_ sender: UIButton) {
    for index in 0..<viewModel.images.count {
        let indexPath = IndexPath(item: index + 1, section: 0)
        guard let cell = photoCollectionView.cellForItem(at: indexPath) as? ItemEditPhotoCollectionViewCell else {
          //BreakPoint
            return
        }
        if cell.deleteButton === sender {
            viewModel.deleteImage(indexPath)
        }
    }
}
```

- 위 코드에서 BreakPoint 발동, 타입 캐스팅이 제대로 이루어지지 않음을 확인

**해결 방법**

- for 문 내에서 `return` 대신 `continue` 키워드를 통해서 반복문을 계속해서 선회할 수 있도록 변경

<br>

### Item 정보를 load한 후, Response Data 중  images들을 load 받는 중 Bug 발생 [(관련 Issue)](https://github.com/kane-young/re-open-market/issues/15)

**문제 진단**

- multi Thread에서 하나의 배열에 동시 접근하여 `UIImage` 를 `append` 할 경우, 3개의 이미지를 `append` 해도 1개의 이미지만 추가되는 문제 발생
- 공유 자원 문제로 파악

**문제 해결**

- 공유 자원에 접근하는 시점을 변경하거나, 공유 자원에 접근할 경우 serialQueue에 넣어주는 방법을 고민함
- multi Thread에서 같은 자원에 동시에 접근하지 않아도 되도록 변경

**before**
```swift
private func loadImages(item: Item) {
    let dispatchGroup = DispatchGroup()
    guard let imagePaths = item.images else { return }
    for imagePath in imagePaths {
        dispatchGroup.enter()
        DispatchQueue(label: "ImageLoadQueue",
                      attributes: .concurrent).async(group: dispatchGroup) { [weak self] in
            self?.imageNetworkUseCase.retrieveImage(with: imagePath) { result in
                switch result {
                case .success(let image):
                    self?.images.append(image) //멀티 쓰레드에서 동시에 images에 접근하여 의도대로 작동하지 않음
                    dispatchGroup.leave()
                case .failure(let error):
                    self?.state = .error(.imageUseCaseError(error))
                }
            }
        }
    }
    dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
        guard let metaData = self?.metaData(for: item) else { return }
        self?.state = .update(metaData)
    }
}
```

**after**
```swift
private func loadImages(item: Item) {
    let dispatchGroup = DispatchGroup()
    guard let imagePaths = item.images else { return }
    var images: [UIImage] = Array(repeating: UIImage(), count: imagePaths.count)
    for index in .zero..<imagePaths.count {
        dispatchGroup.enter()
        DispatchQueue(label: "ImageLoadQueue",
                      attributes: .concurrent).async(group: dispatchGroup) { [weak self] in
            self?.imageNetworkUseCase.retrieveImage(with: imagePaths[index]) { result in
                switch result {
                case .success(let image):
                    images[index] = image //멀티 쓰레드에서 같은 자원에 접근하지 않아도 되도록 코드 수정
                    dispatchGroup.leave()
                case .failure(let error):
                    self?.state = .error(.imageUseCaseError(error))
                }
            }
        }
    }
    dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
        guard let metaData = self?.metaData(for: item) else { return }
        self?.images.append(contentsOf: images)
        self?.state = .update(metaData)
    }
}
```

<br>

### 각 Device Size 별 혹은 회전에 따른 AutoLayout Bug [(관련 Issue)](https://github.com/kane-young/re-open-market/issues/20)

**문제 진단**

- 초기 AutoLayout, View Size를 `traitCollectionDidChange(_:UITraitCollection?)` 메서드를 활용해서 때에 맞춰 수정하도록 구현
- iPad 기기의 경우 `verticalSizeClass`, `horizontalSizeClass` 모두  `regular` 이기 때문에 `UIDevice.orientationDidChangeNotification` 을 활용해서 AutoLayout, View Size 를 변경하도록 함
- `UICollectionViewCell` 의 크기는 회전과 동시에 `reloadData` 를 수행해 줌에도 불구하고 resizing 되지 않는 Bug가 발생

![iPad-resizingBug](https://user-images.githubusercontent.com/64566207/139378169-83fd840d-3323-48fe-9342-03c7f7a83c86.gif)

**문제 해결**

- 많은 포럼 혹은 앱을 참고한 결과, 반드시 필요하지 않은 경우는 `Landscape` 모드를 지원할 필요가 없다고 판단
- 해당 앱을 `Portrait` 전용으로 변경하는 차선책을 선택

<br>

### iPad - Alert(Action Sheet) 관련 이슈 [(관련 Issue)](https://github.com/kane-young/re-open-market/issues/21)

**문제 진단**

- iPad에서 `    UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)` 를 `present` 할 경우 Error 발생
- [iOS Apple Developers Document](https://developer.apple.com/documentation/uikit/uiactionsheet) 에서 iPad의 경우 popover로 display함을 인식

**문제 해결**

- `UIDevice.current.userInterfaceIdiom` 을 통해서 앱 실행 기기가 iPad임을 판단하고 `Action sheet` 을 popover로 설정

```swift
if UIDevice.current.userInterfaceIdiom == .pad {
  	if let popoverController = alertController.popoverPresentationController {
   	 		popoverController.barButtonItem = navigationItem.rightBarButtonItem
  	}
}
```

<br>

### ItemListViewController - Refresh시 Item 배열에 대한 런타임 에러 [(관련 Issue)](https://github.com/kane-young/re-open-market/issues/23)

**문제 진단**

- 스크롤을 빠르게 내리던 도중에 Refresh 할 경우 `cellForRow` 에서  `out of index` error 발생
- BreakPoint를 통해서 당시 `viewModel` 의 state가 .update(indexPaths) 임을 확인, items 배열의 경우 empty임을 인지
- 추가로 load한 마켓 상품 목록이 update 됨과 동시에 items 배열을 `removeAll` 해서 `collectionView` 에서 `insertItems(at: indexPath)` 를 할 경우 에러가 생김을 확인하였다. 따라서 해당 문제가 `loadItems` 메서드가 비동기적으로 작동하기 때문임을 파악함

```swift
private(set) var items: [Item] = [] {
    didSet {
        if oldValue.count > items.count { return }
        let indexPaths = (oldValue.count..<items.count).map { IndexPath(item: $0, section: .zero) }
        if oldValue.count == .zero {
            state = .initial
        } else {
            state = .update(indexPaths)
        }
    }
}

private func viewModelBind() {
    viewModel.bind { [weak self] state in
        switch state {
        case .initial:
            self?.activityIndicator.stopAnimating()
            self?.collectionView.isHidden = false
            self?.collectionView.reloadData()
            self?.collectionView.scrollToItem(at: IndexPath(item: .zero, section: .zero),
                                              at: .top, animated: false)
        case .update(let indexPaths):
            self?.collectionView.insertItems(at: indexPaths)
        case .error(let error):
            self?.alertErrorMessage(error)
        default:
            break
        }
    }
}
```

**문제 해결**

- 이전에 items 변화에 따른 state는 items가 비어있다가 채워질 경우  `.initial`이 되도록, 추가될 경우는 `.update`로 설정하였다. 해당 방법의 경우 `items.removeAll` 에 대한 state 변화가 없으므로, 비동기적으로 `.update`가 수행되는 것을 그대로 수행할 수 밖에 없었다
- 간단하게, `items.count == 0` 이 될 경우,  `.initial 로 state` 변경하고,` indexPath`가 추가되면 state를 `.update`로 변경함으로써 `items.removeAll`에 대한 state 변화를 만족시키도록 변경

<br>

---

## 개선 요구사항

개발 초기 과정에 있어서 완벽하게 feature 개발을 하는 것도 중요하지만, 이후 유저들의 의견을 수렴하여 업데이트를 하는 App 운영도 좋은 App의 조건 중 하나라고 생각됩니다. `App Store` 출시를 통해 실제 유저들의 후기를 들어볼 수는 없었지만, 직접 테스트를 통해 개선해야되는 부분을 정리하였습니다

<br>

### UIImagePicker
`UIImagePicker`를 사용했을 경우 유저가 한번에 하나의 사진밖에 선택하지 못한다

-> `PHPicker(iOS 14.0+)` 등을 활용하여, 사진 선택을 여러 개 할 수 있도록 개선 요망

<br>

### Currency - UITextField

`UIPickerView`를 통해 Currency에 대한 선택을 제한하고 있습니다. 하지만, 커서가 `UITextField`를 통해 노출되고 있음을 발견

-> 보이지 않도록 수정 요망


<img src="https://user-images.githubusercontent.com/64566207/141405809-0537f30a-5466-4517-bfb3-0b55da65f57f.png" width="300">
