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
            var base64PhotoList: [String]
        }
        
        struct ViewModel {
            var photoList: [UIImage]?
            var errorMessage: String?
        }
    }
    
    enum Upload {
        struct Request {
            var photo: UIImage
        }
        
        struct Response {
        }
        
        struct ViewModel {
            var infoMessage: String?
            var errorMessage: String?
        }
    }
}
