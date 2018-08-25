//
//  PhotoCell.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 29/07/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView_photo: UIImageView!
    
    // MARK: - Methods
    func displayContent(image: UIImage) {
        imageView_photo.image = image
    }
}
