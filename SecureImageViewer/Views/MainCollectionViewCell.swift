//
//  MainCollectionViewCell.swift
//  SecureImageViewer
//
//  Created by Артур Фомин on 01.10.2022.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - methods
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
