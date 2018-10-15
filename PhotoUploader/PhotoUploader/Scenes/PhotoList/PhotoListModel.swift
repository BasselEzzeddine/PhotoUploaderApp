//
//  PhotoListModel.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 29/07/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit

enum PhotoListModel {
    enum Fetch {
        struct Request {
        }
        
        struct Response {
            let base64PhotoList: [String]
        }
        
        struct ViewModel {
            let photoList: [UIImage]?
            let errorMessage: String?
        }
    }
    
    enum Upload {
        struct Request {
            let photo: UIImage
        }
        
        struct Response {
        }
        
        struct ViewModel {
            let infoMessage: String?
            let errorMessage: String?
        }
    }
}
