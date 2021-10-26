//
//  PhotoCellViewModelTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/25.
//

import XCTest
@testable import OpenMarket

class PhotoCellViewModelTests: XCTestCase {
    func test_photoCellViewModel_configureCell호출시_state_update로변경() throws {
        //given
        let expectation = XCTestExpectation()
        guard let dummyImage = Dummy.image else {
            XCTFail()
            return
        }
        let photoCellViewModel = PhotoCellViewModel(image: dummyImage)
        photoCellViewModel.bind { state in
            switch state {
            case .update(_):
                //then
                expectation.fulfill()
            case .empty:
                XCTFail()
            }
        }
        //when
        photoCellViewModel.configureCell()
        wait(for: [expectation], timeout: 2.0)
    }
}
