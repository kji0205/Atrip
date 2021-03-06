//
//  MainTipCollectionViewCell.swift
//  Atrip
//
//  Created by jimmy on 2020/05/02.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class MainTipCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "MainTipCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MainTipCollectionViewCell", bundle: nil)
    }
    
    var data: MainScreenDataBanner? {
        didSet {
            guard let data = self.data else { return }
            self.imageView.downloaded(from: data.imgurl)
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
             imageView.isUserInteractionEnabled = true
            
        }
    }
    
//    fileprivate let bg: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        return iv
//    }()
    
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

protocol CollectionViewCellDelegate: class {
    func didTapCell(url: URL)
}
