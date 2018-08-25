//
//  PhotoListConfigurator.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 04/08/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

extension PhotoListInteractor: PhotoListViewControllerOutput {
}

extension PhotoListViewController: PhotoListPresenterOutput {
}

extension PhotoListPresenter: PhotoListInteractorOutput {
}

class PhotoListConfigurator {
    
    // MARK: - Properties
    static let sharedInstance = PhotoListConfigurator()
    
    // MARK: - Methods
    func configure(viewController: PhotoListViewController) {
        let interactor = PhotoListInteractor()
        viewController.output = interactor
        
        let presenter = PhotoListPresenter()
        presenter.output = viewController
        
        interactor.output = presenter
    }
}
