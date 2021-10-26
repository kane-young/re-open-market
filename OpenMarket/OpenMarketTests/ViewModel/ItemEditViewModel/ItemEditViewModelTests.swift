//
//  ItemEditViewModelTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/25.
//

import XCTest
@testable import OpenMarket

final class ItemEditViewModelTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_itemEditViewModel_validate호출성공시_state_satisfy로변경() {
        let itemEditViewModel = ItemEditViewModel()
        itemEditViewModel.bind { [weak self] state in
            switch state {
            case .satisfied:
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemEditViewModel.addImage(Dummy.image)
        itemEditViewModel.validate(titleText: "iPhone13 mini", stockText: "13", currencyText: "USD", priceText: "10000", discountedPriceText: "8500", descriptionsText: "2021년 출시된 iPhone 시리즈")
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemEditViewModel_validate호출실패시_state_dissatisfy로변경() {
        let itemEditViewModel = ItemEditViewModel()
        itemEditViewModel.bind { [weak self] state in
            switch state {
            case .dissatisfied:
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemEditViewModel.validate(titleText: nil, stockText: nil, currencyText: nil, priceText: nil,
                                   discountedPriceText: nil, descriptionsText: nil)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemEditViewModel_loadItem호출성공시_state_initial로변경() {
        let stubSuccessItemEditNetworkUseCase = StubSuccessItemEditNetworkUseCase()
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemEditViewModel = ItemEditViewModel(itemEditNetworkUseCase: stubSuccessItemEditNetworkUseCase,
                                                  imageNetworkUseCase: stubSuccessImageNetworkUseCase)
        itemEditViewModel.validate(titleText: Dummy.titleText, stockText: Dummy.stockText,
                                   currencyText: Dummy.currencyText, priceText: Dummy.priceText,
                                   discountedPriceText: Dummy.discountedPriceText,
                                   descriptionsText: Dummy.descriptionsText)
        itemEditViewModel.bind { [weak self] state in
            switch state {
            case .loading:
                fallthrough
            case .initial(_):
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemEditViewModel.loadItem(id: Dummy.id)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemEditViewModel_registerItem호출성공시_state_register로변경() {
        let stubSuccessItemEditNetworkUseCase = StubSuccessItemEditNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemEditViewModel = ItemEditViewModel(itemEditNetworkUseCase: stubSuccessItemEditNetworkUseCase,
                                                  imageNetworkUseCase: dummyImageNetworkUseCase)
        itemEditViewModel.validate(titleText: Dummy.titleText, stockText: Dummy.stockText,
                                   currencyText: Dummy.currencyText, priceText: Dummy.priceText,
                                   discountedPriceText: Dummy.discountedPriceText,
                                   descriptionsText: Dummy.descriptionsText)
        itemEditViewModel.bind { [weak self] state in
            switch state {
            case .loading:
                fallthrough
            case .register(_):
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemEditViewModel.registerItem(password: Dummy.password)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemEditViewModel_updateItem호출성공시_state_update로변경() {
        let stubSuccessItemEditNetworkUseCase = StubSuccessItemEditNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemEditViewModel = ItemEditViewModel(itemEditNetworkUseCase: stubSuccessItemEditNetworkUseCase,
                                                  imageNetworkUseCase: dummyImageNetworkUseCase)
        itemEditViewModel.validate(titleText: Dummy.titleText, stockText: Dummy.stockText,
                                   currencyText: Dummy.currencyText, priceText: Dummy.priceText,
                                   discountedPriceText: Dummy.discountedPriceText,
                                   descriptionsText: Dummy.descriptionsText)
        itemEditViewModel.bind { [weak self] state in
            switch state {
            case .loading:
                fallthrough
            case .update(_):
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemEditViewModel.updateItem(password: Dummy.password)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemEditViewModel_loadItem호출실패시_state_error로변경() {
        let stubFailureItemEditNetworkUseCase = StubFailureItemEditNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemEditViewModel = ItemEditViewModel(itemEditNetworkUseCase: stubFailureItemEditNetworkUseCase,
                                                  imageNetworkUseCase: dummyImageNetworkUseCase)
        itemEditViewModel.validate(titleText: Dummy.titleText, stockText: Dummy.stockText,
                                   currencyText: Dummy.currencyText, priceText: Dummy.priceText,
                                   discountedPriceText: Dummy.discountedPriceText,
                                   descriptionsText: Dummy.descriptionsText)
        itemEditViewModel.bind { [weak self] state in
            switch state {
            case .loading:
                fallthrough
            case .error(_):
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemEditViewModel.loadItem(id: Dummy.id)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemEditViewModel_registerItem호출실패시_state_error로변경() {
        let stubFailureItemEditNetworkUseCase = StubFailureItemEditNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemEditViewModel = ItemEditViewModel(itemEditNetworkUseCase: stubFailureItemEditNetworkUseCase,
                                                  imageNetworkUseCase: dummyImageNetworkUseCase)
        itemEditViewModel.validate(titleText: Dummy.titleText, stockText: Dummy.stockText,
                                   currencyText: Dummy.currencyText, priceText: Dummy.priceText,
                                   discountedPriceText: Dummy.discountedPriceText,
                                   descriptionsText: Dummy.descriptionsText)
        itemEditViewModel.bind { [weak self] state in
            switch state {
            case .loading:
                fallthrough
            case .error(_):
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemEditViewModel.registerItem(password: Dummy.password)
        wait(for: [expectation], timeout: 2.0)
    }

    func test_itemEditViewModel_updateItem호출실패시_state_error로변경() {
        let stubFailureItemEditNetworkUseCase = StubFailureItemEditNetworkUseCase()
        let dummyImageNetworkUseCase = ImageNetworkUseCase()
        let itemEditViewModel = ItemEditViewModel(itemEditNetworkUseCase: stubFailureItemEditNetworkUseCase,
                                                  imageNetworkUseCase: dummyImageNetworkUseCase)
        itemEditViewModel.validate(titleText: Dummy.titleText, stockText: Dummy.stockText,
                                   currencyText: Dummy.currencyText, priceText: Dummy.priceText,
                                   discountedPriceText: Dummy.discountedPriceText,
                                   descriptionsText: Dummy.descriptionsText)
        itemEditViewModel.bind { [weak self] state in
            switch state {
            case .loading:
                fallthrough
            case .error(_):
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        itemEditViewModel.updateItem(password: Dummy.password)
        wait(for: [expectation], timeout: 2.0)
    }
}
