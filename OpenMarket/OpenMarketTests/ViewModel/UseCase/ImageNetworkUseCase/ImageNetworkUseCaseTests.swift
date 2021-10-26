//
//  ThumbnailUseCaseTests.swift
//  OpenMarketTests
//
//  Created by 이영우 on 2021/10/04.
//

import XCTest
@testable import OpenMarket

final class ImageNetworkUseCaseTests: XCTestCase {
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        expectation = XCTestExpectation()
    }

    override func tearDownWithError() throws {
        expectation = nil
    }

    func test_when_retrieveImage성공시_then_image반환() {
        //given
        let stubSuccessImageNetworkManager = StubSuccessImageNetworkManager()
        let imageNetworkUseCase = ImageNetworkUseCase(networkManager: stubSuccessImageNetworkManager)
        let dummyThumbnailPath = Dummy.thumbnailUrlString
        guard let expectedImage = UIImage(data: (UIImage(systemName: "pencil")?.pngData())!) else {
            XCTFail()
            return
        }
        //when
        imageNetworkUseCase.retrieveImage(with: dummyThumbnailPath) { [weak self] result in
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

    func test_when_Data이미지로변환실패시_then_ConvertDataToImageError반환() {
        //given
        let dummyThumbnailPath = Dummy.thumbnailUrlString
        let stubSuccessItemNetworkManager = StubSuccessItemNetworkManager()
        let imageNetworkUseCase = ImageNetworkUseCase(networkManager: stubSuccessItemNetworkManager)
        let expectedError = ImageNetworkUseCaseError.convertDataToImageError
        //when
        imageNetworkUseCase.retrieveImage(with: dummyThumbnailPath) { [weak self] result in
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

    func test_when_networking실패시_then_networkError반환() {
        //given
        let dummyThumbnailPath = Dummy.thumbnailUrlString
        let stubFailureNetworkManager = StubFailureNetworkManager()
        let imageNetworkUseCase = ImageNetworkUseCase(networkManager: stubFailureNetworkManager)
        let expectedError = ImageNetworkUseCaseError.networkError(.connectionProblem)
        //when
        imageNetworkUseCase.retrieveImage(with: dummyThumbnailPath) { [weak self] result in
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
