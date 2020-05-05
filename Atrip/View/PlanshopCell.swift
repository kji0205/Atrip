//
//  PlanshopCell.swift
//  Atrip
//
//  Created by jimmy on 2020/05/04.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class PlanshopCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    static let identifier = "PlanshopCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "PlanshopCell", bundle: nil)
    }
 
    var data: MainScreenDataBanner? {
        didSet {
            guard let data = self.data else { return }
            self.image.downloaded(from: data.imgurl, contentMode: .scaleAspectFill)
//            self.image.contentMode = .scaleAspectFill
            
            image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
            image.isUserInteractionEnabled = true
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc func imageTapped(_ img: AnyObject) {
        guard let url = URL(string: data?.link ?? "") else { return }
        tapAction(url: url)
    }
    
    weak var delegate: CollectionViewCellDelegate?

    func tapAction(url: URL) {
        if let del = self.delegate {
            del.didTapCell(url: url)
        }
    }
    
}
