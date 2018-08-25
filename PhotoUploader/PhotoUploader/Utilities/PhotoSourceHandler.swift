//
//  PhotoSourceHandler.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 05/08/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit

class PhotoSourceHandler: NSObject, UINavigationControllerDelegate {
    
    // MARK: - Properties
    static let sharedInstance = PhotoSourceHandler()
    fileprivate var currentViewController: UIViewController?
    var imagePickedBlock: ((UIImage) -> Void)?
    
    // MARK: - Methods
    func displayPhotoChoosingPopup(viewController: UIViewController) {
        currentViewController = viewController
        let alertController = UIAlertController(title: "Choose your photo from :", message: "", preferredStyle: .alert)
        
        let photosAction = UIAlertAction(title: "Photos", style: .default) { (action:UIAlertAction!) in
            self.openPhotosLibrary()
        }
        alertController.addAction(photosAction)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction!) in
            self.openCamera()
        }
        alertController.addAction(cameraAction)
        
        currentViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func openPhotosLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            currentViewController?.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            currentViewController?.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoSourceHandler: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }
        currentViewController?.dismiss(animated: true, completion: nil)
    }
}
