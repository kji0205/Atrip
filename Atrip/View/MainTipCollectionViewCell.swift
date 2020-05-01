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
            
//            let imageView = UIImageView()
//            let url = URL(string: data.imgurl)
//            do {
//                let data = try Data(contentsOf: url!)
//                imageView.image = UIImage(data: data)
//
////                imageView.contentMode = .scaleAspectFill
////                imageView.frame = CGRect(x: 0, y: 0, width: 112, height: 112)
//
//            } catch  {
//                print("image no loading")
//            }
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
        
//        contentView.addSubview(bg)
//        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        bg.bottomAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
//    }
    
    fileprivate func setup() {
        self.addSubview(imageView)
//        imageView.anchor(top: self.topAnchor, left: self.leftAnchor,
//                         bottom: nil, right: nil,
//                         paddingTop: 0, paddingLeft: 0,
//                         paddingBottom: 0, paddingRight: 0,
//                         width: 0, height: 0)
    }
    
}
