//
//  ThumbnailUseCaseTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

final class ThumbnailUseCaseTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_ThumbnailUseCase_retrieveImage성공() {
        //given
        let useCase = ThumbnailUseCase(networkManager: StubSuccessThumbnailNetworkManager())
        guard let expectedImage = UIImage(data: (UIImage(systemName: "pencil")?.pngData())!) else {
            XCTFail()
            return
        }
        //when
        useCase.retrieveImage(with: Dummy.thumbnailUrlString) { [weak self] result in
            switch result {
            case .success(let image):
                //then
                XCTAssertEqual(expectedImage.pngData(), image.pngData())
                self?.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_ThumbnailUseCase_ConvertDataToImageError() {
        //given
        let useCase = ThumbnailUseCase(networkManager: StubSuccessItemDetailNetworkManager())
        let expectedError = ThumbnailUseCaseError.convertDataToImageError
        //when
        useCase.retrieveImage(with: Dummy.thumbnailUrlString) { [weak self] result in
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

    func test_ThumbnailUseCase_networkError() {
        //given
        let useCase = ThumbnailUseCase(networkManager: StubFailureNetworkManager())
        let expectedError = ThumbnailUseCaseError.networkError(.connectionProblem)
        //when
        useCase.retrieveImage(with: Dummy.thumbnailUrlString) { [weak self] result in
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
}
