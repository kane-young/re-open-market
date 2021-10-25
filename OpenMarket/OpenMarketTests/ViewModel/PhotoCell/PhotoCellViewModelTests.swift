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
        guard let expectedImage = UIImage(named: "OpenMarket") else {
            XCTFail()
            return
        }
        let photoCellViewModel = PhotoCellViewModel(image: expectedImage)
        //when
        photoCellViewModel.bind { state in
            switch state {
            case .update(let image):
                //then
                XCTAssertEqual(image, expectedImage)
            case .empty:
                XCTFail()
            }
        }
        photoCellViewModel.configureCell()
    }
}
