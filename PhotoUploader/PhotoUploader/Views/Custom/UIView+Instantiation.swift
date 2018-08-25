//
//  UIView+Instantiation.swift
//  PhotoUploader
//
//  Created by Bassel Ezzeddine on 16/08/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit

extension UIView {
    static func fromNib<T : UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)?.first as? T
    }
}
