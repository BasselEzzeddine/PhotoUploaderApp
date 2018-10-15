//
//  PhotoListViewController.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 29/07/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit

protocol PhotoListViewControllerInput {
    func displayPhotoList(viewModel: PhotoListModel.Fetch.ViewModel)
    func displayFetchError(viewModel: PhotoListModel.Fetch.ViewModel)
    func displayUploadSuccess(viewModel: PhotoListModel.Upload.ViewModel)
    func displayUploadError(viewModel: PhotoListModel.Upload.ViewModel)
}

protocol PhotoListViewControllerOutput {
    func fetchPhotoList()
    func uploadPhoto(request: PhotoListModel.Upload.Request)
}

class PhotoListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var output: PhotoListViewControllerOutput?
    private let configurator = PhotoListConfigurator()
    var photoSourceHandler = PhotoSourceHandler.sharedInstance
    private let numberOfCellsPerRow = 2
    private let minimumSpacingBetweenCellsInRow: CGFloat = 10
    private let rowEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    private var photoList = [UIImage]()
    
    // MARK: - UIViewController
    override func awakeFromNib() {
        super.awakeFromNib()
        configurator.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.fetchPhotoList()
        activityIndicator.isHidden = false
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        collectionView.allowsSelection = false
    }
    
    // MARK: - Actions
    @IBAction func button_add_clicked(_ sender: Any) {
        photoSourceHandler.displayPhotoChoosingPopup(viewController: self)
        photoSourceHandler.imagePickedBlock = { (image) in
            let request = PhotoListModel.Upload.Request(photo: image)
            self.output?.uploadPhoto(request: request)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let image = photoList[indexPath.item]
        cell.displayContent(image: image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return rowEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacingBetweenCellsInRow
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.size.width
        let numberOfCellsPerRowFloatValue = CGFloat(numberOfCellsPerRow)
        let cellWidth = (collectionViewWidth - rowEdgeInsets.left - rowEdgeInsets.right - minimumSpacingBetweenCellsInRow * (numberOfCellsPerRowFloatValue - 1)) / numberOfCellsPerRowFloatValue
        let cellHeight = cellWidth * 0.8
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - PhotoListViewControllerInput
extension PhotoListViewController: PhotoListViewControllerInput {
    func displayPhotoList(viewModel: PhotoListModel.Fetch.ViewModel) {
        guard let photoList = viewModel.photoList else {
            return
        }
        self.photoList = photoList
        collectionView.reloadData()
        activityIndicator.isHidden = true
    }
    
    func displayFetchError(viewModel: PhotoListModel.Fetch.ViewModel) {
        guard let message = viewModel.errorMessage else {
            return
        }
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        activityIndicator.isHidden = true
    }
    
    func displayUploadSuccess(viewModel: PhotoListModel.Upload.ViewModel) {
        self.output?.fetchPhotoList()
        self.activityIndicator.isHidden = false
        
        guard let message = viewModel.infoMessage else {
            return
        }
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        activityIndicator.isHidden = true
    }
    
    func displayUploadError(viewModel: PhotoListModel.Upload.ViewModel) {
        guard let message = viewModel.errorMessage else {
            return
        }
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        activityIndicator.isHidden = true
    }
}
