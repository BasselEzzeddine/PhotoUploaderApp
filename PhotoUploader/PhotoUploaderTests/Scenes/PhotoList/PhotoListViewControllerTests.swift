//
//  PhotoListViewControllerTests.swift
//  PhotoUploaderTests
//
//  Created by Bassel Ezzeddine on 29/07/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import PhotoUploader

class PhotoListViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: PhotoListViewController!
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
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = mainStoryboard.instantiateViewController(withIdentifier: "PhotoListViewController") as! PhotoListViewController
        UIApplication.shared.keyWindow?.rootViewController = sut
    }
    
    func getPhotoCellForItemAtPosition(_ position: Int) -> PhotoCell {
        let indexPath = IndexPath(item: position, section: 0)
        return sut.collectionView.cellForItem(at: indexPath) as! PhotoCell
    }
    
    // MARK: - Mocks
    class OutputMock: PhotoListViewControllerOutput {
        var fetchPhotoListWasCalled = false
        var uploadPhotoWasCalled = false
        var uploadPhotoRequest: PhotoListModel.Upload.Request?
        
        func fetchPhotoList() {
            fetchPhotoListWasCalled = true
        }
        
        func uploadPhoto(request: PhotoListModel.Upload.Request) {
            uploadPhotoWasCalled = true
            uploadPhotoRequest = request
        }
    }
    
    class PhotoSourceHandlerMock: PhotoSourceHandler {
        var displayPhotoChoosingPopupWasCalled = false
        
        override func displayPhotoChoosingPopup(viewController: UIViewController) {
            displayPhotoChoosingPopupWasCalled = true
        }
    }
    
    // MARK: - Tests
    func testCallingDisplayPhotoList_displaysCorrectData() {
        // When
        let redPhoto = UIImage(named: "red.png", in: testBundle, compatibleWith: nil)!
        let greenPhoto = UIImage(named: "green.png", in: testBundle, compatibleWith: nil)!
        let bluePhoto = UIImage(named: "blue.png", in: testBundle, compatibleWith: nil)!
        let photoList = [redPhoto, greenPhoto, bluePhoto]
        let viewModel = PhotoListModel.Fetch.ViewModel(photoList: photoList, errorMessage: nil)
        sut.displayPhotoList(viewModel: viewModel)
        
        // Then
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        
        XCTAssertEqual(sut.collectionView.numberOfSections, 1)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 3)
        
        let cell1 = getPhotoCellForItemAtPosition(0)
        XCTAssertEqual(cell1.imageView_photo.image, redPhoto)
        
        let cell2 = getPhotoCellForItemAtPosition(1)
        XCTAssertEqual(cell2.imageView_photo.image, greenPhoto)
        
        let cell3 = getPhotoCellForItemAtPosition(2)
        XCTAssertEqual(cell3.imageView_photo.image, bluePhoto)
    }
    
    func testWhenViewLoads_callsFetchPhotoListInOutput() {
        // Given
        let outputMock = OutputMock()
        sut.output = outputMock
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(outputMock.fetchPhotoListWasCalled)
    }
    
    func testCallingDisplayFetchError_showsAlertControllerWithCorrectMessage() {
        // When
        let viewModel = PhotoListModel.Fetch.ViewModel(photoList: nil, errorMessage: "Error message")
        sut.displayFetchError(viewModel: viewModel)
        
        // Then
        XCTAssertTrue(sut.presentedViewController is UIAlertController)
        XCTAssertEqual((sut.presentedViewController as! UIAlertController).message, "Error message")
    }
    
    func testWhenClickingAddButton_callsDisplayPhotoChoosingPopupInPhotoSourceHandler() {
        // Given
        let photoSourceHandlerMock = PhotoSourceHandlerMock()
        sut.photoSourceHandler = photoSourceHandlerMock
        
        // When
        sut.button_add_clicked(sut.navigationItem.rightBarButtonItem!)
        
        // Then
        XCTAssertTrue(photoSourceHandlerMock.displayPhotoChoosingPopupWasCalled)
    }
    
    func testWhenClickingAddButton_andReceivingImageFromPhotoSourceHandler_callsUploadPhotoInOutputWithCorrectRequest() {
        // Given
        let outputMock = OutputMock()
        sut.output = outputMock
        
        let photoSourceHandlerMock = PhotoSourceHandlerMock()
        sut.photoSourceHandler = photoSourceHandlerMock
        
        // When
        sut.button_add_clicked(sut.navigationItem.rightBarButtonItem!)
        
        let redPhoto = UIImage(named: "red.png", in: testBundle, compatibleWith: nil)!
        photoSourceHandlerMock.imagePickedBlock?(redPhoto)
        
        // Then
        XCTAssertTrue(outputMock.uploadPhotoWasCalled)
        
        let request = outputMock.uploadPhotoRequest
        XCTAssertEqual(request?.photo, redPhoto)
    }
    
    func testCallingDisplayUploadSuccess_showsAlertControllerWithCorrectMessage() {
        // When
        let viewModel = PhotoListModel.Upload.ViewModel(infoMessage: "Success message", errorMessage: nil)
        sut.displayUploadSuccess(viewModel: viewModel)
        
        // Then
        XCTAssertTrue(sut.presentedViewController is UIAlertController)
        XCTAssertEqual((sut.presentedViewController as! UIAlertController).message, "Success message")
    }
    
    func testCallingDisplayUploadSuccess_callsFetchPhotoListInOutput() {
        // Given
        let outputMock = OutputMock()
        sut.output = outputMock
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(outputMock.fetchPhotoListWasCalled)
    }
    
    func testCallingDisplayUploadError_showsAlertControllerWithCorrectMessage() {
        // When
        let viewModel = PhotoListModel.Upload.ViewModel(infoMessage: nil, errorMessage: "Error message")
        sut.displayUploadError(viewModel: viewModel)
        
        // Then
        XCTAssertTrue(sut.presentedViewController is UIAlertController)
        XCTAssertEqual((sut.presentedViewController as! UIAlertController).message, "Error message")
    }
}
