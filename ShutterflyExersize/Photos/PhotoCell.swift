//
//  PhotoCell.swift
//  ShutterflyExersize
//
//  Created by Red Pill on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    var photo: UIImage? {
        get { return imgPhoto.image }
        set { imgPhoto.image = newValue }
    }
    
    var isLoading: Bool = false {
        didSet {
            loadingView.isHidden = !isLoading
            spinner.startAnimating()
        }
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var imgPhoto: UIImageView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    //MARK: -
    
    
    
}
