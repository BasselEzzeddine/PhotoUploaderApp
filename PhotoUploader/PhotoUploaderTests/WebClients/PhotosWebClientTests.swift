//
//  PhotosWebClientTests.swift
//  PhotoUploaderTests
//
//  Created by Bassel Ezzeddine on 04/08/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import PhotoUploader

class PhotosWebClientTests: XCTestCase {
    
    // MARK: - Properties
    var sut: PhotosWebClient!
    let mockServer = MockServer()
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSut()
    }
    
    override func tearDown() {
        mockServer.stop()
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Methods
    func setupSut() {
        sut = PhotosWebClient()
    }
    
    // MARK: - Tests
    func testCallingFetchPhotoList_returnsCorrectDataFromServer_whenHavingSuccess() {
        // Given
        mockServer.respondToFetchPhotoListWithSuccess()
        mockServer.start()
        
        // When
        let expectation = self.expectation(description: "Wait server response")
        sut.fetchPhotoList(completionHandler: {
            (rawPhotoList, success) in
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(rawPhotoList)
            XCTAssertEqual(rawPhotoList?.base64Images[0], "x1")
            XCTAssertEqual(rawPhotoList?.base64Images[1], "x2")
            XCTAssertEqual(rawPhotoList?.base64Images[2], "x3")
            
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testCallingFetchPhotoList_returnsCorrectDataFromServer_whenHavingFailure() {
        // Given
        mockServer.respondToFetchPhotoListWithFailure()
        mockServer.start()
        
        // When
        let expectation = self.expectation(description: "Wait server response")
        sut.fetchPhotoList(completionHandler: {
            (rawPhotoList, success) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(rawPhotoList)
            
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 3, handler: nil)
    }
}
