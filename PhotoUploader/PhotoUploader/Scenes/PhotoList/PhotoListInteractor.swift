//
//  PhotoListInteractor.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 29/07/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol PhotoListInteractorInput {
    func fetchPhotoList()
    func uploadPhoto(request: PhotoListModel.Upload.Request)
}

protocol PhotoListInteractorOutput {
    func presentPhotoList(response: PhotoListModel.Fetch.Response)
    func presentFetchError()
    func presentUploadSuccess()
    func presentUploadError()
}

class PhotoListInteractor {
    
    // MARK: - Properties
    var output: PhotoListInteractorOutput?
    var photosWebClient = PhotosWebClient()
    
    // MARK: - Methods
    private func handleFetchPhotoListResponse(_ rawPhotoList: RawPhotoList?, _ success: Bool) {
        if let rawPhotoList = rawPhotoList, success {
            let response = PhotoListModel.Fetch.Response(base64PhotoList: rawPhotoList.base64Images)
            output?.presentPhotoList(response: response)
        }
        else {
            output?.presentFetchError()
        }
    }
    
    private func handleUploadPhotoResponse(_ success: Bool) {
        if success {
            output?.presentUploadSuccess()
        }
        else {
            output?.presentUploadError()
        }
    }
}

// MARK: - PhotoListInteractorInput
extension PhotoListInteractor: PhotoListInteractorInput {
    func fetchPhotoList() {
        photosWebClient.fetchPhotoList(completionHandler: { [weak self]
            (rawPhotoList, success) in
            self?.handleFetchPhotoListResponse(rawPhotoList, success)
        })
    }
    
    func uploadPhoto(request: PhotoListModel.Upload.Request) {
        photosWebClient.uploadPhoto(request.photo, completionHandler: { [weak self]
            (success) in
            self?.handleUploadPhotoResponse(success)
        })
    }
}
