//
//  PhotosWebClient.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 29/07/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit
import Alamofire

class PhotosWebClient {
    
    // MARK: - Methods
    func fetchPhotoList(completionHandler: @escaping(_ rawPhotoList: RawPhotoList?, _ success: Bool) -> Void) {
        guard let url = URL(string: ("http://localhost:8080/images/download")) else {
            completionHandler(nil, false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    do {
                        let decoder = JSONDecoder()
                        let rawPhotoList = try decoder.decode(RawPhotoList.self, from: data)
                        completionHandler(rawPhotoList, true)
                    }
                    catch {
                        completionHandler(nil, false)
                    }
                }
                else {
                    completionHandler(nil, false)
                }
            }
        }).resume()
    }
    
    func uploadPhoto(_ photo: UIImage, completionHandler: @escaping(_ success: Bool) -> Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let imageData = UIImageJPEGRepresentation(photo, 0.1)
            if let imageData = imageData {
                multipartFormData.append(imageData, withName: "file", fileName: "", mimeType: "image/jpeg")
            }
        }, usingThreshold: UInt64.init(), to: "http://localhost:8080/images/upload", method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    if response.value == "success" {
                        completionHandler(true)
                    }
                    else {
                        completionHandler(false)
                    }
                }
            case .failure(_):
                completionHandler(false)
            }
        }
    }
}
