//
//  MainMenuCollectionViewCell.swift
//  Atrip
//
//  Created by jimmy on 2020/04/26.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class MainMenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    static let identifier = "MainMenuCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with image: UIImage) {
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MainMenuCollectionViewCell", bundle: nil)
    }
}
