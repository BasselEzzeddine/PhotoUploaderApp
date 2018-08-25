//
//  PhotoListPresenter.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 04/08/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit

protocol PhotoListPresenterInput {
    func presentPhotoList(response: PhotoListModel.Fetch.Response)
    func presentFetchError()
    func presentUploadSuccess()
    func presentUploadError()
}

protocol PhotoListPresenterOutput: class {
    func displayPhotoList(viewModel: PhotoListModel.Fetch.ViewModel)
    func displayFetchError(viewModel: PhotoListModel.Fetch.ViewModel)
    func displayUploadSuccess(viewModel: PhotoListModel.Upload.ViewModel)
    func displayUploadError(viewModel: PhotoListModel.Upload.ViewModel)
}

class PhotoListPresenter {
    
    // MARK: - Properties
    weak var output: PhotoListPresenterOutput?
    
    private func base64ToImage(_ base64: String) -> UIImage {
        let dataDecoded = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        return decodedimage!
    }
}

extension PhotoListPresenter: PhotoListPresenterInput {
    func presentPhotoList(response: PhotoListModel.Fetch.Response) {
        var photoList = [UIImage]()
        for base64Image in response.base64PhotoList {
            let image = base64ToImage(base64Image)
            photoList.append(image)
        }
        let viewModel = PhotoListModel.Fetch.ViewModel(photoList: photoList, errorMessage: nil)
        output?.displayPhotoList(viewModel: viewModel)
    }
    
    func presentFetchError() {
        let viewModel = PhotoListModel.Fetch.ViewModel(photoList: nil, errorMessage: "A download error has occurred. Please try again later.")
        output?.displayFetchError(viewModel: viewModel)
    }
    
    func presentUploadSuccess() {
        let viewModel = PhotoListModel.Upload.ViewModel(infoMessage: "Upload complete.", errorMessage: nil)
        output?.displayUploadSuccess(viewModel: viewModel)
    }
    
    func presentUploadError() {
        let viewModel = PhotoListModel.Upload.ViewModel(infoMessage: nil, errorMessage: "An upload error has occurred. Please try again later.")
        output?.displayUploadError(viewModel: viewModel)
    }
}
