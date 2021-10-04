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
        expectation = XCTestExpectation(description: "Bind Success")
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_when_cell구성요소_설정성공시_then_state_update로변경() {
        //given
        let itemListCellViewModel = ItemListCellViewModel(item: Dummy.normalItem,
                                                          useCase: StubSuccessThumbnailUseCase())
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
        let itemListCellViewModel = ItemListCellViewModel(item: Dummy.normalItem,
                                                          useCase: StubFailureThumbnailUseCase())
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
        let itemListCellViewModel = ItemListCellViewModel(item: Dummy.emptyThumbnailItem,
                                                          useCase: StubSuccessThumbnailUseCase())
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

    func test_when_일반Item로cell구성요소_설정성공시_then_metaData비교() {
        //given
        let itemListCellViewModel = ItemListCellViewModel(item: Dummy.normalItem,
                                                          useCase: StubSuccessThumbnailUseCase())
        let expectedStockText = "수량 : 12"
        let expectedStockTextColor = UIColor.label
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

    func test_when_품절Item로cell구성요소_설정성공시_then_metaData비교() {
        //given
        let itemListCellViewModel = ItemListCellViewModel(item: Dummy.outOfStockItem,
                                                          useCase: StubSuccessThumbnailUseCase())
        let expectedStockText = "품절"
        let expectedStockTextColor = UIColor.systemYellow
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

    func test_when_1000개이상의Item로cell구성요소_설정성공시_then_metaData비교() {
        //given
        let itemListCellViewModel = ItemListCellViewModel(item: Dummy.quantitiousItem,
                                                          useCase: StubSuccessThumbnailUseCase())
        let expectedStockText = "수량 : 999+"
        let expectedStockTextColor = UIColor.label
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
}
