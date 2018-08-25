//
//  PhotoListInteractorTests.swift
//  PhotoUploaderTests
//
//  Created by Bassel Ezzeddine on 29/07/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import PhotoUploader

class PhotoListInteractorTests: XCTestCase {
    
    // MARK: - Properties
    var sut: PhotoListInteractor!
    let testBundle = Bundle(for: PhotoListViewControllerTests.self)
    
    // MARK: - XCTestCase
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
        sut = PhotoListInteractor()
    }
    
    // MARK: - Mocks
    class OutputMock: PhotoListInteractorOutput {
        var presentPhotoListWasCalled = false
        var presentPhotoListWasCalledResponse: PhotoListModel.Fetch.Response?
        var presentFetchErrorWasCalled = false
        
        var presentUploadSuccessWasCalled = false
        var presentUploadErrorWasCalled = false
        
        func presentPhotoList(response: PhotoListModel.Fetch.Response) {
            presentPhotoListWasCalled = true
            presentPhotoListWasCalledResponse = response
        }
        
        func presentFetchError() {
            presentFetchErrorWasCalled = true
        }
        
        func presentUploadSuccess() {
            presentUploadSuccessWasCalled = true
        }
        
        func presentUploadError() {
            presentUploadErrorWasCalled = true
        }
    }
    
    class PhotosWebClientMock: PhotosWebClient {
        var fetchPhotoListWasCalled = false
        var rawPhotoListToBeReturned: RawPhotoList?
        var successToBeReturnedFromFetchPhotoList = false
        
        var uploadPhotoWasCalled = false
        var uploadPhotoPassedPhoto: UIImage?
        var successToBeReturnedFromUploadPhoto = false
        
        override func fetchPhotoList(completionHandler: @escaping (RawPhotoList?, Bool) -> Void) {
            fetchPhotoListWasCalled = true
            completionHandler(rawPhotoListToBeReturned, successToBeReturnedFromFetchPhotoList)
        }
        
        override func uploadPhoto(_ photo: UIImage, completionHandler: @escaping (Bool) -> Void) {
            uploadPhotoWasCalled = true
            uploadPhotoPassedPhoto = photo
            completionHandler(successToBeReturnedFromUploadPhoto)
        }
    }
    
    // MARK: - Tests
    func testCallingFetchPhotoList_callsFetchPhotoListInPhotosWorker() {
        // Given
        let photosWebClientMock = PhotosWebClientMock()
        sut.photosWebClient = photosWebClientMock
        
        // When
        sut.fetchPhotoList()
        
        // Then
        XCTAssertTrue(photosWebClientMock.fetchPhotoListWasCalled)
    }
    
    func testCallingFetchPhotoList_callsPresentPhotoListInOutputWithCorrectResponse_whenReceivingNonNilDataFromWorkerAndSuccess() {
        // Given
        let photosWebClientMock = PhotosWebClientMock()
        sut.photosWebClient = photosWebClientMock
        
        let outputMock = OutputMock()
        sut.output = outputMock
        
        // When
        photosWebClientMock.rawPhotoListToBeReturned = RawPhotoList(base64Images: ["x1", "x2", "x3"])
        photosWebClientMock.successToBeReturnedFromFetchPhotoList = true
        sut.fetchPhotoList()
        
        // Then
        XCTAssertTrue(outputMock.presentPhotoListWasCalled)
        
        let response = outputMock.presentPhotoListWasCalledResponse
        XCTAssertEqual(response?.base64PhotoList[0], "x1")
        XCTAssertEqual(response?.base64PhotoList[1], "x2")
        XCTAssertEqual(response?.base64PhotoList[2], "x3")
    }
    
    func testCallingFetchPhotoList_callsPresentErrorInOutput_whenReceivingNilDataFromWorker() {
        // Given
        let photosWebClientMock = PhotosWebClientMock()
        sut.photosWebClient = photosWebClientMock
        
        let outputMock = OutputMock()
        sut.output = outputMock
        
        // When
        photosWebClientMock.rawPhotoListToBeReturned = nil
        photosWebClientMock.successToBeReturnedFromFetchPhotoList = true
        sut.fetchPhotoList()
        
        // Then
        XCTAssertTrue(outputMock.presentFetchErrorWasCalled)
    }
    
    func testCallingFetchPhotoList_callsPresentErrorInOutput_whenReceivingFailureFromWorker() {
        // Given
        let photosWebClientMock = PhotosWebClientMock()
        sut.photosWebClient = photosWebClientMock
        
        let outputMock = OutputMock()
        sut.output = outputMock
        
        // When
        photosWebClientMock.rawPhotoListToBeReturned = RawPhotoList(base64Images: [])
        photosWebClientMock.successToBeReturnedFromFetchPhotoList = false
        sut.fetchPhotoList()
        
        // Then
        XCTAssertTrue(outputMock.presentFetchErrorWasCalled)
    }
    
    func testCallingUploadPhoto_callsUploadPhotoInPhotosWorkerWithCorrectData() {
        // Given
        let photosWebClientMock = PhotosWebClientMock()
        sut.photosWebClient = photosWebClientMock
        
        // When
        let redPhoto = UIImage(named: "red.png", in: testBundle, compatibleWith: nil)!
        let request = PhotoListModel.Upload.Request(photo: redPhoto)
        sut.uploadPhoto(request: request)
        
        // Then
        XCTAssertTrue(photosWebClientMock.uploadPhotoWasCalled)
        XCTAssertEqual(photosWebClientMock.uploadPhotoPassedPhoto, redPhoto)
    }
    
    func testCallingUploadPhoto_callsPresentUploadSuccessInOutput_whenReceivingSuccessFromWorker() {
        // Given
        let photosWebClientMock = PhotosWebClientMock()
        sut.photosWebClient = photosWebClientMock
        
        let outputMock = OutputMock()
        sut.output = outputMock
        
        // When
        photosWebClientMock.successToBeReturnedFromUploadPhoto = true
        let redPhoto = UIImage(named: "red.png", in: testBundle, compatibleWith: nil)!
        let request = PhotoListModel.Upload.Request(photo: redPhoto)
        sut.uploadPhoto(request: request)
        
        // Then
        XCTAssertTrue(outputMock.presentUploadSuccessWasCalled)
    }
    
    func testCallingUploadPhoto_callsPresentErrorInOutput_whenReceivingFailureFromWorker() {
        // Given
        let photosWebClientMock = PhotosWebClientMock()
        sut.photosWebClient = photosWebClientMock
        
        let outputMock = OutputMock()
        sut.output = outputMock
        
        // When
        photosWebClientMock.successToBeReturnedFromUploadPhoto = false
        let redPhoto = UIImage(named: "red.png", in: testBundle, compatibleWith: nil)!
        let request = PhotoListModel.Upload.Request(photo: redPhoto)
        sut.uploadPhoto(request: request)
        
        // Then
        XCTAssertTrue(outputMock.presentUploadErrorWasCalled)
    }
}
