//
//  HashTagCollectionViewCell.swift
//  Atrip
//
//  Created by jimmy on 2020/05/03.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class HashTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    static let identifier = "HashTagCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HashTagCollectionViewCell", bundle: nil)
    }
    
    var data: MainScreenDataHashTag? {
        didSet {
            guard let data = self.data else { return }
            self.title.text = data.text
            self.title.sizeToFit()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
