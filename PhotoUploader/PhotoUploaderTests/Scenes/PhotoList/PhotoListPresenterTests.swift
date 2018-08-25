//
//  PhotoListPresenterTests.swift
//  PhotoUploaderTests
//
//  Created by Bassel Ezzeddine on 04/08/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import PhotoUploader

class PhotoListPresenterTests: XCTestCase {
    
    // MARK: - Properties
    var sut: PhotoListPresenter?
    let testBundle = Bundle(for: PhotoListViewControllerTests.self)
    
    // MARK: -
    override func setUp() {
        super.setUp()
        setupSut()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Methods
    func setupSut() {
        sut = PhotoListPresenter()
    }
    
    // MARK: - Mocks
    class OutputMock: PhotoListPresenterOutput {
        var displayPhotoListWasCalled = false
        var displayPhotoListViewModel: PhotoListModel.Fetch.ViewModel?
        
        var displayFetchErrorWasCalled = false
        var displayFetchErrorViewModel: PhotoListModel.Fetch.ViewModel?
        
        var displayUploadSuccessWasCalled = false
        var displayUploadSuccessViewModel: PhotoListModel.Upload.ViewModel?
        
        var displayUploadErrorWasCalled = false
        var displayUploadErrorViewModel: PhotoListModel.Upload.ViewModel?
        
        func displayPhotoList(viewModel: PhotoListModel.Fetch.ViewModel) {
            displayPhotoListWasCalled = true
            displayPhotoListViewModel = viewModel
        }
        
        func displayFetchError(viewModel: PhotoListModel.Fetch.ViewModel) {
            displayFetchErrorWasCalled = true
            displayFetchErrorViewModel = viewModel
        }
        
        func displayUploadSuccess(viewModel: PhotoListModel.Upload.ViewModel) {
            displayUploadSuccessWasCalled = true
            displayUploadSuccessViewModel = viewModel
        }
        
        func displayUploadError(viewModel: PhotoListModel.Upload.ViewModel) {
            displayUploadErrorWasCalled = true
            displayUploadErrorViewModel = viewModel
        }
    }
    
    // MARK: - Tests
    func testCallingPresentPhotoList_callsDisplayPhotoListInOutputWithCorrectViewModel() {
        // Given
        let outputMock = OutputMock()
        sut?.output = outputMock
        
        // When
        let response = PhotoListModel.Fetch.Response(base64PhotoList: Base64Samples.array)
        sut?.presentPhotoList(response: response)
        
        // Then
        XCTAssertTrue(outputMock.displayPhotoListWasCalled)
        
        let firstPhoto = UIImage(named: "eiffel.jpg", in: testBundle, compatibleWith: nil)!
        let secondPhoto = UIImage(named: "louvre.jpg", in: testBundle, compatibleWith: nil)!
        let thirdPhoto = UIImage(named: "profile.jpg", in: testBundle, compatibleWith: nil)!
        
        let viewModel = outputMock.displayPhotoListViewModel
        XCTAssertEqual(UIImagePNGRepresentation(viewModel!.photoList![0]), UIImagePNGRepresentation(firstPhoto))
        XCTAssertEqual(UIImagePNGRepresentation(viewModel!.photoList![1]), UIImagePNGRepresentation(secondPhoto))
        XCTAssertEqual(UIImagePNGRepresentation(viewModel!.photoList![2]), UIImagePNGRepresentation(thirdPhoto))
        
        XCTAssertNil(viewModel?.errorMessage)
    }
    
    func testCallingPresentFetchError_callsDisplayFetchErrorInOutputWithCorrectViewModel() {
        // Given
        let outputMock = OutputMock()
        sut?.output = outputMock
        
        // When
        sut?.presentFetchError()
        
        // Then
        XCTAssertTrue(outputMock.displayFetchErrorWasCalled)
        
        let viewModel = outputMock.displayFetchErrorViewModel
        XCTAssertNil(viewModel?.photoList)
        XCTAssertEqual(viewModel?.errorMessage, "A download error has occurred. Please try again later.")
    }
    
    func testCallingPresentUploadSuccess_callsDisplayUploadSuccessInOutputWithCorrectViewModel() {
        // Given
        let outputMock = OutputMock()
        sut?.output = outputMock
        
        // When
        sut?.presentUploadSuccess()
        
        // Then
        XCTAssertTrue(outputMock.displayUploadSuccessWasCalled)
        
        let viewModel = outputMock.displayUploadSuccessViewModel
        XCTAssertEqual(viewModel?.infoMessage, "Upload complete.")
        XCTAssertNil(viewModel?.errorMessage)
    }
    
    func testCallingPresentUploadError_callsDisplayUploadErrorInOutputWithCorrectViewModel() {
        // Given
        let outputMock = OutputMock()
        sut?.output = outputMock
        
        // When
        sut?.presentUploadError()
        
        // Then
        XCTAssertTrue(outputMock.displayUploadErrorWasCalled)
        
        let viewModel = outputMock.displayUploadErrorViewModel
        XCTAssertNil(viewModel?.infoMessage)
        XCTAssertEqual(viewModel?.errorMessage, "An upload error has occurred. Please try again later.")
    }
}
