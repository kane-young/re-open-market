//
//  ItemListCellViewModelTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

final class ItemListCellViewModelTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_when_cell구성요소_설정성공시_then_state_update로변경() {
        //given
        let dummyItem = Dummy.itemDetail
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemListCellViewModel = ItemListCellViewModel(item: dummyItem,
                                                          useCase: stubSuccessImageNetworkUseCase)
        itemListCellViewModel.bind { [weak self] state in
            switch state {
            case .update(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_cell구성요소_설정실패시_then_state_error로변경() {
        //given
        let dummyItem = Dummy.itemDetail
        let stubFailureImageNetworkUseCase = StubFailureImageNetworkUseCase()
        let itemListCellViewModel = ItemListCellViewModel(item: dummyItem,
                                                          useCase: stubFailureImageNetworkUseCase)
        itemListCellViewModel.bind { [weak self] state in
            switch state {
            case .error(_):
                //then
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_emptyThumbnailItem구성요소_설정시_then_state_error로변경() {
        //given
        let emptyThumbnailItem = Item(id: 1, title: "iPad", descriptions: nil, price: 100000, currency: "KRW",
                                      stock: 1000, discountedPrice: nil, thumbnails: [], images: nil,
                                      registrationDate: 3.0)
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemListCellViewModel = ItemListCellViewModel(item: emptyThumbnailItem,
                                                          useCase: stubSuccessImageNetworkUseCase)
        itemListCellViewModel.bind { [weak self] state in
            switch state {
            case .error(let error):
                //then
                XCTAssertEqual(error, .emptyPath)
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_일반Item로cell구성요소_설정성공시_then_stockInfo비교() {
        //given
        let normalItem = Item(id: 1, title: "12", descriptions: nil, price: 33, currency: "KRW", stock: 12,
                              discountedPrice: nil, thumbnails: ["naver.com"], images: nil, registrationDate: 33123)
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemListCellViewModel = ItemListCellViewModel(item: normalItem,
                                                          useCase: stubSuccessImageNetworkUseCase)
        let expectedStockText = "수량 : 12"
        let expectedStockTextColor = ItemListCellViewModel.Format.Stock.defaultColor
        itemListCellViewModel.bind { [weak self] state in
            switch state {
            case .update(let metaData):
                //then
                XCTAssertEqual(metaData.stock, expectedStockText)
                XCTAssertEqual(metaData.stockLabelTextColor, expectedStockTextColor)
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_품절Item로cell구성요소_설정성공시_then_stockInfo비교() {
        //given
        let outOfStockItem = Item(id: 1, title: "iPad", descriptions: nil, price: 100000, currency: "KRW",
                                  stock: 0, discountedPrice: nil, thumbnails: ["www.kane.com"], images: nil,
                                  registrationDate: 3.0)
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemListCellViewModel = ItemListCellViewModel(item: outOfStockItem,
                                                          useCase: stubSuccessImageNetworkUseCase)
        let expectedStockText = ItemListCellViewModel.Format.Stock.soldOutText
        let expectedStockTextColor = ItemListCellViewModel.Format.Stock.soldOutColor
        itemListCellViewModel.bind { [weak self] state in
            switch state {
            case .update(let metaData):
                //then
                XCTAssertEqual(metaData.stock, expectedStockText)
                XCTAssertEqual(metaData.stockLabelTextColor, expectedStockTextColor)
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_1000개이상의Item로cell구성요소_설정성공시_then_stockInfo비교() {
        //given
        let quantitiousItem = Item(id: 1, title: "iPad", descriptions: nil, price: 100000, currency: "KRW",
                                   stock: 1000, discountedPrice: nil, thumbnails: ["www.kane.com"], images: nil,
                                   registrationDate: 3.0)
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemListCellViewModel = ItemListCellViewModel(item: quantitiousItem,
                                                          useCase: stubSuccessImageNetworkUseCase)
        let expectedStockText = "수량 : 999+"
        let expectedStockTextColor = ItemListCellViewModel.Format.Stock.defaultColor
        itemListCellViewModel.bind { [weak self] state in
            switch state {
            case .update(let metaData):
                //then
                XCTAssertEqual(metaData.stock, expectedStockText)
                XCTAssertEqual(metaData.stockLabelTextColor, expectedStockTextColor)
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_ItemListCellViewModel_할인가격이존재할경우_then_priceLabelTextColor확인() {
        //given
        let discountedItem = Item(id: 50, title: "title", descriptions: "descriptions", price: 50000,
                                  currency: "USD", stock: 100, discountedPrice: 3000, thumbnails: [""],
                                  images: nil, registrationDate: 123123411)
        let expectedPriceLabelTextColor = ItemListCellViewModel.Format.Stock.discountedPriceTextColor
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemListCellViewModel = ItemListCellViewModel(item: discountedItem,
                                                          useCase: stubSuccessImageNetworkUseCase)
        itemListCellViewModel.bind { [weak self] state in
            switch state {
            case .update(let metaData):
                //then
                XCTAssertEqual(expectedPriceLabelTextColor, metaData.priceLabelTextColor)
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_when_ItemListCellViewModel_할인가격이존재할경우_then_priceLabelText_strikeThrough적용() {
        //given
        let discountedItem = Item(id: 50, title: "title", descriptions: "descriptions", price: 30000,
                                  currency: "KRW", stock: 100, discountedPrice: 3000, thumbnails: [""],
                                  images: nil, registrationDate: 123123411)
        let expectedPriceText = "KRW 30,000".strikeThrough()
        let stubSuccessImageNetworkUseCase = StubSuccessImageNetworkUseCase()
        let itemListCellViewModel = ItemListCellViewModel(item: discountedItem, useCase: stubSuccessImageNetworkUseCase)
        itemListCellViewModel.bind { [weak self] state in
            switch state {
            case .update(let metaData):
                //then
                XCTAssertEqual(expectedPriceText, metaData.originalPrice)
                self?.expectation.fulfill()
            default:
                XCTFail()
            }
        }
        //when
        itemListCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }
}
