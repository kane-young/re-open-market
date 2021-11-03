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



## 설계 및 구현

### ViewController 구성

<img src="https://user-images.githubusercontent.com/64566207/139639565-049e26e1-1b1d-420d-bdc4-428a5ea8b943.png" width="800"/>



### MVVM 구조

View와 Model을 서로 독립시키며, ViewModel에 대한 Unit Test를 진행하기 위해서 MVVM을 채택하였습니다.

또한 프로토콜을 통한 추상화를 통해서 의존성 역전시켜, 의존성 주입을 통해 외부 의존성과 무관한 테스트를 진행하였습니다

![스크린샷 2021-11-01 오후 8 44 11](https://user-images.githubusercontent.com/64566207/139666697-52e57762-95e8-4b9c-b3fd-8f1b6f31abae.png)

-  각 View와 View Model 공통 구현 사항
  - 각 View Model은 State 타입을 가지고 있으며, Instance stored property로 State를 가지고 있다
  - View Model은 `bind(_ handler: (state) -> Void)` 메서드를 통해 `handler` 를 등록하며, ViewModel의 `state` 가 변경될 때마다 Property Observer를 통해서 해당 `handler` 를 동작시킨다.



### 타입 역할 분배

**Model - Network**

| struct / protocol / enum              | 역할                                                         |
| ------------------------------------- | ------------------------------------------------------------ |
| `NetworkManager/NetworkManagable`     | - URLSession을 통한 http 통신을 진행하고, 이에 대한 response를 처리 |
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



### View객체들 간에 이벤트 주고 받기 - Delegate, Notification

View가 사용자로부터 이벤트가 발생할 경우 다른 View 또한 해당 이벤트에 대해 반응하기 위해 Delegate 혹은 Notification, KVO가 필요하다

<img src="https://user-images.githubusercontent.com/64566207/140001869-69a7f015-c167-4c1d-aea9-9e05f0ebe45a.png" width="650">

<img src="https://user-images.githubusercontent.com/64566207/140001772-21d3492b-ced8-4041-926f-376daa4d350d.png" width="650">

<img src="https://user-images.githubusercontent.com/64566207/140001778-9f264fbf-2296-4586-82ea-e6fcb74e7a06.png" width="650">

<img src="https://user-images.githubusercontent.com/64566207/140001769-b06566d0-3617-45f5-9646-dfc67cffd770.png" width="950">



### 상품 조회

